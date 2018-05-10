# elm-lazy-list

This package is used to represent an infinite list of values, to be computed as they are needed. It is mainly designed for use with Elm test. 

    singleton 5
        |> cons 6
        -- only evaluated here!
        |> toList --> 6, 5 

It is recommended that you don't use this package unless you really need to -- in the future, it is likely to be in-lined into elm-test directly. You are more likely to be better served by implementing laziness yourself, for the data structure that you need!