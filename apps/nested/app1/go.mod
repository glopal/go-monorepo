module app1

go 1.23.0

require (
	core v0.0.0
	extra v0.0.0
	github.com/spf13/cobra v1.8.1
)

require (
	github.com/inconshreveable/mousetrap v1.1.0 // indirect
	github.com/spf13/pflag v1.0.5 // indirect
)

replace core => ../../../common/core

replace extra => ../../../common/extras

replace app1 => .
