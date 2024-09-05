package main

import (
	"core"
	"extra"
	"fmt"

	"github.com/spf13/cobra"
)

func main() {
	fmt.Println(core.String(), extra.String())

	_ = cobra.Command{}
}
