module Pizza
    exposing
        ( Base
        , Topping
        , Pizza
        , addTopping
        , bases
        , toppings
        , new
        , hasTopping
        , countAllToppings
        , countTopping
        , removeTopping
        )

import Dict exposing (Dict)


type alias Base =
    String


type alias Topping =
    String


type alias Pizza =
    { base : Base
    , toppings : Dict Topping Int
    }


new : Base -> Pizza
new base =
    { base = base, toppings = newToppings }


newToppings : Dict Topping Int
newToppings =
    List.foldr (\topping result -> Dict.insert topping 0 result) Dict.empty toppings


addTopping : Topping -> Pizza -> Pizza
addTopping topping pizza =
    { pizza | toppings = Dict.update topping incrementToppingCount pizza.toppings }


incrementToppingCount : Maybe Int -> Maybe Int
incrementToppingCount maybeTopping =
    applyWithDefault 1 ((+) 1) maybeTopping


hasTopping : Topping -> Pizza -> Bool
hasTopping topping pizza =
    Dict.get topping pizza.toppings
        |> Maybe.map ((<) 0)
        |> Maybe.withDefault False


countTopping : Topping -> Pizza -> Int
countTopping topping pizza =
    Maybe.withDefault 0 (Dict.get topping pizza.toppings)


countAllToppings : Pizza -> Int
countAllToppings pizza =
    List.sum (Dict.values pizza.toppings)


removeTopping : Topping -> Pizza -> Pizza
removeTopping topping pizza =
    { pizza | toppings = Dict.update topping decrementToppingCount pizza.toppings }


decrementToppingCount : Maybe Int -> Maybe Int
decrementToppingCount maybeTopping =
    applyWithDefault 0 (\x -> x - 1) maybeTopping


applyWithDefault : b -> (a -> b) -> Maybe a -> Maybe b
applyWithDefault default fn maybe =
    Maybe.map fn maybe |> Maybe.withDefault default |> Just


bases : List Base
bases =
    [ "Margherita", "Bianco" ]


toppings : List Topping
toppings =
    [ "Pineapple", "Spam", "Honey", "Walnuts", "Cherries", "Feta" ]
