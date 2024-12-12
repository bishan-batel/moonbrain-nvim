/**
 * @file Moonbrain grammar for tree-sitter
 * @author Kishan S Patel <bishan.batel@protonmail.com>
 * @license MIT
 */

/// <reference types="tree-sitter-cli/dsl" />
// @ts-check

module.exports = grammar({
  name: "moonbrain",
  extras: $ => [/\s|\\\r?\n/, $.comment],
  inline: $ => [$._expression, $._statement],
  word: $ => $.identifier,

  rules: {
    source_file: $ => seq(
      seq($.directive)
    ),

    directive: $ => seq(
      field("name", seq("@", $.identifier)),
      optional(seq(
        "(",
        commaSep(choice(prec(1000, $.var_name_decl), $.string, $.number, $.bool, $.char)),
        ")"
      )),
      optional(";")
    ),

    identifier: _ => /[^0-9\s\[\]\(\)\!\@\#\$\%\^\&\*\-\+\{\}<>\,\.\`\~\/\\\;\:\'\"][^\s\[\]\(\)\!\@\#\$\%\^\&\*\-\+\{\}<>\,\.\`\~\/\\\;\:\'\"]*/,
    number: _ => token(/[0-9]+\.?[0-9]*/),

    type: $ => $.identifier,

    var_name_decl: $ => seq(field("name", $.identifier), optional(seq(":", $.type))),

    _statement: $ => choice(
      $.if_statement,
      $.match_statement,
      $.while_statement,
      $.for_statement,
      $.fn_statement,
      $.variable_declare,
      $.return_statement,
      $._expression,
    ),

    variable_declare: $ => seq(
      choice('let', 'var'),
      choice(
        $.var_name_decl,
        seq(
          "[",
          commaSep1($.var_name_decl),
          "]",
        )
      ),
      seq(
        '=',
        field('initial', $._expression),
      )
    ),


    _expression: $ => choice(
      $.identifier,
      $.number,
      $.string,
      $.bool,
      $.function_call,
      $.fn_statement,
      $.array,
      $.paren_expression,
      $.binary_expression,
      $.unary_expression,
      $.match_statement,
      $.property_expression,
      $.if_statement,
      $.is_expression,
      $.block,
    ),

    is_expression: $ => prec.right(100, seq($._expression, "is", optional("not"), sep1($.type, ":"))),

    fn_statement: $ => seq(
      choice("func", "entrypoint"),
      optional(
        field("name", $.identifier)
      ),
      optional(seq(
        '(',
        commaSep(
          field('param', $.var_name_decl)),
        ')'
      )),
      $.block
    ),

    array: $ => seq('[', commaSep($._expression), ']'),
    return_statement: $ => prec.left(500, seq("return", optional($._expression))),

    for_statement: $ => seq(
      "for",
      $.var_name_decl,
      "in",
      $._expression,
      choice(
        seq("do", $._statement),
        $.block
      )
    ),

    while_statement: $ => seq(
      choice("while", "until"),
      $._expression,
      $.block
    ),

    if_statement: $ => prec.left(500, seq(
      choice("if", "unless"),
      $._expression,
      $.block,
      optional(
        seq(
          "else",
          $.block,
        ),
      )
    )),

    match_case: $ => seq(
      $._expression,
      '=>',
      choice($.block, seq($._expression, ',')),
    ),

    match_statement: $ => prec.left(500, seq(
      'match',
      $._expression,
      '{',
      repeat(choice($.match_case)),
      optional(seq('default', '=>', choice($.block, seq($._expression)))),
      '}'
    )),

    block: $ => prec(50, seq('{', repeat(seq($._statement, optional(';'))), field('evaluation', optional($._expression)), '}')),

    property_expression: $ => prec.left(601, seq(
      prec.left(600, sep1($._expression, choice('.', ':'))),
      choice(".", ':'),
      choice(
        field("property", $.identifier),
        field("method", $.function_call),
      )
    )),

    function_call: $ => prec(203, (seq(
      field('name', $.identifier),
      seq('(', commaSep($._expression), ')')
    ))),


    paren_expression: $ => seq('(', $._expression, ')'),

    binary_expression: ($) =>
      choice(
        prec.left(
          1,
          seq(
            $._expression,
            choice("%=", "^=", "&=", "*=", "-=", "+=", "|=", "/=", "=",),
            $._expression
          )
        ),
        prec.left(2, seq($._expression, "or", $._expression)),
        prec.left(3, seq($._expression, "and", $._expression)),
        prec.left(4, seq($._expression, "|", $._expression)),
        prec.left(5, seq($._expression, "^", $._expression)),
        prec.left(6, seq($._expression, "&", $._expression)),
        prec.left(7, seq($._expression, choice("==", "!="), $._expression)),
        prec.left(
          8,
          seq($._expression, choice("<", "<=", ">", ">="), $._expression)
        ),
        prec.left(9, seq($._expression, choice(">>", "<<"), $._expression)),
        prec.left(10, seq($._expression, choice("+", "-"), $._expression)),
        prec.left(11, seq($._expression, choice("/", "*", "%", "mod"), $._expression)),
      ),

    unary_expression: $ => prec.left(100, seq(choice("not", "-"), $._expression)),

    string: $ => choice(
      seq('"',
        repeat(choice(
          field('char', $.char),
          field('escaped', seq('{', $._expression, '}'))
        )),
        '"'),
      seq('"""',
        repeat(choice(
          field('char', $.char),
          field('escaped', seq('{', $._expression, '}'))
        )),
        '"""'),
    ),
    char: _ => (choice(
      "\\n",
      "\\r",
      "\\\"",
      /([^"^{]|(\{\{))+/
    )),
    bool: _ => choice("true", "false"),
    comment: _ => token(seq('\/\/', /.*/, '\n')),
  }
});

/**
 * @param {RuleOrLiteral} rule
 * @param {RuleOrLiteral} separator
 * @returns {ChoiceRule} 
 */
function sep(rule, separator) {
  return optional(sep1(rule, separator));
}

/**
 * @param {RuleOrLiteral} rule 
 * @param {RuleOrLiteral} separator 
 * @returns {SeqRule} 
 */
function sep1(rule, separator) {
  return seq(rule, repeat(seq(separator, rule)));
}

/**
 * @param {RuleOrLiteral} rule 
 * @returns {RuleOrLiteral} 
 */
function commaSep1(rule) {
  return sep1(rule, ",");
}

/**
 * @param {RuleOrLiteral} rule 
 * @returns {ChoiceRule} 
 */
function commaSep(rule) {
  return optional(commaSep1(rule));
}

/**
 * @param {RuleOrLiteral} rule 
 * @returns {ChoiceRule} 
 */
function commaSepTrailing(rule) {
  return optional(seq(rule, repeat(seq(',', rule)), optional(',')));
}
