module go-monorepo

go 1.23.0

replace core => ./common/core

replace extra => ./common/extras

replace app2 => ./apps/app2

replace app1 => ./apps/nested/app1
