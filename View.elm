module View exposing (view)

import Dict exposing (Dict)
import Html exposing (Html)
import Html.Attributes as Attributes
import Html.Events as Events
import Pizza
import Types exposing (Model, Msg(..))


view : Model -> Html Msg
view model =
    case model of
        Nothing ->
            baseSelector

        Just pizza ->
            pizzaBuilder pizza


baseSelector : Html Msg
baseSelector =
    Html.div [] (List.map baseButton Pizza.bases)


baseButton : Pizza.Base -> Html Msg
baseButton base =
    Html.button [ Events.onClick (Types.SelectBase base) ] [ Html.text base ]


pizzaBuilder : Pizza.Pizza -> Html Msg
pizzaBuilder pizza =
    Html.div []
        [ Html.div [] [ Html.text ("Base is " ++ pizza.base) ]
        , Html.div [] [ Html.text "Toppings are: ", displayToppings pizza ]
        ]


displayToppings : Pizza.Pizza -> Html Msg
displayToppings pizza =
    Html.div []
        (List.map
            (\topping -> Html.li [] [ topping ])
            (List.map (displayTopping pizza) (Dict.keys pizza.toppings))
        )


displayTopping : Pizza.Pizza -> Pizza.Topping -> Html Msg
displayTopping pizza topping =
    Html.span []
        [ Html.text (topping ++ "(")
        , removeToppingButton pizza topping
        , Html.text (toString (Maybe.withDefault 0 (Dict.get topping pizza.toppings)))
        , addToppingButton pizza topping
        , Html.text ")"
        ]


addToppingButton : Pizza.Pizza -> Pizza.Topping -> Html Msg
addToppingButton pizza topping =
    Html.button
        [ Events.onClick (Types.AddTopping topping)
        , Attributes.disabled (toppingIsAvailable pizza topping)
        ]
        [ Html.text ("+") ]


removeToppingButton : Pizza.Pizza -> Pizza.Topping -> Html Msg
removeToppingButton pizza topping =
    Html.button
        [ Events.onClick (Types.RemoveTopping topping)
        , Attributes.disabled (not (Pizza.hasTopping topping pizza))
        ]
        [ Html.text "-" ]


toppingIsAvailable : Pizza.Pizza -> Pizza.Topping -> Bool
toppingIsAvailable pizza topping =
    Pizza.countTopping topping pizza >= 2 || Pizza.countAllToppings pizza >= 10
