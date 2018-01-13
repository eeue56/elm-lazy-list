module Example exposing (..)

import Expect exposing (Expectation)
import Fuzz exposing (Fuzzer, int, intRange, list, string)
import Test exposing (..)
import Lazy.List exposing (..)


suite : Test
suite =
    describe "List.lazy"
        [ test "Empty things are empty"
            (\_ ->
                empty
                    |> isEmpty
                    |> Expect.true "Empty is empty"
            )
        , test "A list of two things has two things"
            (\_ ->
                singleton 5
                    |> cons 6
                    |> toList
                    |> Expect.equal [ 6, 5 ]
            )
        , test "The sum is correctly computed"
            (\_ ->
                singleton 10
                    |> cons 6
                    |> sum
                    |> Expect.equal 16
            )
        , fuzz (intRange 0 4000)
            "Drop should drop exactly n elements"
            (\n ->
                numbers
                    |> drop n
                    |> head
                    |> Expect.equal (Just (n + 1))
            )
        , describe "dropWhile"
            [ fuzz (intRange 1 4000)
                "should drop all elements that match the predicate"
                (\n ->
                    numbers
                        |> dropWhile (\x -> x < n)
                        |> head
                        |> Expect.equal (Just n)
                )
            , test "should not overflow the stack"
                (\_ ->
                    numbers
                        |> dropWhile (\x -> x < 10000)
                        |> head
                        |> Expect.equal (Just 10000)
                )
            ]
        ]
