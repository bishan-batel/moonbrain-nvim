package tree_sitter_moonbrain_test

import (
	"testing"

	tree_sitter "github.com/tree-sitter/go-tree-sitter"
	tree_sitter_moonbrain "github.com/bishan-batel/tree-sitter-moonbrain/bindings/go"
)

func TestCanLoadGrammar(t *testing.T) {
	language := tree_sitter.NewLanguage(tree_sitter_moonbrain.Language())
	if language == nil {
		t.Errorf("Error loading Moonbrain grammar")
	}
}
