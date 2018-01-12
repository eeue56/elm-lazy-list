module Main exposing (..)

import Benchmark exposing (..)
import Benchmark.Runner exposing (BenchmarkProgram, program)
import Lazy.List exposing (..)


suite : Benchmark
suite =
    describe "Lazy.List"
        [ benchmark "drop" <|
            \_ ->
                numbers
                    |> drop 500
                    |> head
        ]


main : BenchmarkProgram
main =
    program suite
