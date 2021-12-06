module Main exposing (..)

import Browser
import Html exposing (Html, text, ul, li, pre)
import Html.Attributes exposing (style)
import BigInt exposing (BigInt)
import Dict exposing (Dict)
import Http

main =
  Browser.element { init = init, update = update, subscriptions = subscriptions, view = view }


type Model
  = Failure
  | Loading
  | Success String


init : () -> (Model, Cmd Msg)
init _ = ( Loading , Http.get { url = "./input.txt", expect = Http.expectString GotText } )


type Msg = GotText (Result Http.Error String)

update : Msg -> Model -> (Model, Cmd Msg)
update msg _ =
  case msg of
    GotText result ->
      case result of
        Ok fullText ->
          (Success fullText, Cmd.none)
        Err _ ->
          (Failure, Cmd.none)



subscriptions : Model -> Sub Msg
subscriptions _ =
  Sub.none

view : Model -> Html Msg
view model =
  case model of
    Failure ->
      text "Could not load the input..."
    Loading ->
      text "Loading..."
    Success input ->
      ul [ style "list-style" "none"]
      [
        li [] [ pre [] [ text "Answers" ]],
        li [] [ pre [] [text ("Part One: " ++ (solve input 80))]],
        li [] [ pre [] [text ("Part Two: " ++ (solve input 256))]]
      ]


initNum : Maybe Int -> Int
initNum x  =
    Maybe.withDefault 0 x

sumFish : List (Int, Int) -> BigInt -> BigInt
sumFish pool numFishes =
  case pool of
    (_, count) :: tail ->
      sumFish tail (BigInt.add numFishes (BigInt.fromInt count))
    [] -> numFishes

getNumReproduce : Int -> Int -> Int -> Int
getNumReproduce age count acc =
  if age == 0 then
    count + acc
  else
    acc

updatePool numNewFish poolList newPool =
  case poolList of
    (age, count) :: tail ->
      if age == 0 then
        updatePool numNewFish tail newPool
      else
        updatePool numNewFish tail (Dict.insert (age - 1) count newPool)
    [] -> Dict.update 6 (addOrIncrement numNewFish) (Dict.update 8 (addOrIncrement numNewFish) newPool)

processFish : Int -> Dict Int Int -> BigInt
processFish days pool =
  case days of
    0 -> sumFish (Dict.toList pool) (BigInt.fromInt 0)
    _ ->
      processFish (days - 1) (updatePool (Dict.foldl getNumReproduce 0 pool) (Dict.toList pool) zeroPool)

addOrIncrement amount val =
  case val of
    Just v -> Just (v + amount)
    Nothing -> Just amount

initPool lst pool =
  case lst of
    head :: tail ->
      initPool tail (Dict.update head (addOrIncrement 1) pool)
    [] -> pool

defaultPool pool lst =
  case lst of
    head :: tail ->
      defaultPool (Dict.insert head 0 pool) tail
    [] -> pool

zeroPool =
  defaultPool Dict.empty (List.range 0 8)

solve : String -> Int -> String
solve input numDays =
  BigInt.toString (processFish numDays (initPool (List.map initNum (List.map String.toInt (String.split "," (String.trim input)))) zeroPool))