# go-monorepo

An example approach of how to detect changes to a deployable module. This repo has two "deployable" modules under `./apps` and two "library" modules under `./common`
```
├── apps            // deployables
│   ├── app2        // module
│   └── nested
│       └── app1    // module
└── common          // libraries
    ├── core        // module
    └── extras      // module
```

Run `task build` to see generated checksums for the deployable modules.
```
➜  go-monorepo git:(main) ✗ task build
task: Task "clean" is up to date
app2 - ba9b846f41876cd70dcb3293c46cba84
app1 - 317f9f7a2ffe083a5c6827122889f143
```

Importantly, the checksum includes any dependent local modules. As an example, the `app1` module has dependencies on both the `core` and `extra` modules. If you update code in either of the local dependancies, the checksum will reflect it.

This is accomplished by hacking up the `go.mod`s to allow for local vendoring.
