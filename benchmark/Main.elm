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
        , benchmark "dropWhile" <|
            \_ ->
                numbers
                    |> dropWhile (\x -> x < 500)
                    |> head
        , benchmark "unique" <|
            \_ ->
                repeat 5
                    |> take 500
                    |> unique
                    |> head
        , benchmark "toList" <|
            \_ ->
                numbers
                    |> take 500
                    |> toList
        ]


main : BenchmarkProgram
main =
    program suite
