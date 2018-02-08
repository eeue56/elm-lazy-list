module Example exposing (..)

import Array
import Expect exposing (Expectation)
import Fuzz exposing (Fuzzer, int, intRange, list, string)
import Lazy.List exposing (..)
import Test exposing (..)


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
        , describe "unique"
            [ test "should drop all non-uniqe elements"
                (\_ ->
                    interleave numbers numbers
                        |> take (2 * 500)
                        |> unique
                        |> length
                        |> Expect.equal 500
                )
            , test "should not overflow the stack"
                (\_ ->
                    repeat 5
                        |> take 10000
                        |> unique
                        |> head
                        |> Expect.equal (Just 5)
                )
            ]
        , describe "toArray"
            [ test "should correctly convert a list" <|
                let
                    reference =
                        Array.fromList <| List.range 1 10

                    input =
                        fromArray reference
                in
                \_ ->
                    input
                        |> toArray
                        |> Expect.equal reference
            , test "should not overflow the stack" <|
                \_ ->
                    repeat 5
                        |> take 10000
                        |> toArray
                        |> always Expect.pass
            ]
        , describe "toList"
            [ test "should correctly convert a list" <|
                let
                    reference =
                        List.range 1 10

                    input =
                        fromList reference
                in
                \_ ->
                    input
                        |> toList
                        |> Expect.equal reference
            , test "should not overflow the stack" <|
                \_ ->
                    repeat 5
                        |> take 100000
                        |> toList
                        |> always Expect.pass
            ]
        , describe "foldr"
            [ test "should fold in the right direction" <|
                let
                    reference =
                        List.range 1 10

                    input =
                        fromList reference
                in
                \_ ->
                    input
                        |> foldr (::) []
                        |> Expect.equal reference
            , test "should not overflow the stack" <|
                \_ ->
                    repeat 5
                        |> take 10000
                        |> foldr (+) 0
                        |> always Expect.pass
            ]
        , describe "member"
            [ test "should find a value in a list" <|
                \_ ->
                    numbers
                        |> take 5
                        |> member 3
                        |> Expect.equal True
            , test "should not find a value that is not in the list" <|
                \_ ->
                    numbers
                        |> take 5
                        |> member 10
                        |> Expect.equal False
            , test "should not overflow the stack" <|
                \_ ->
                    numbers
                        |> take 10000
                        |> member -1
                        |> always Expect.pass
            ]
        ]
