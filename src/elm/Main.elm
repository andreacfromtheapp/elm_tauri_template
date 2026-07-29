port module Main exposing (main)

import Accessibility.Aria as Aria
import Browser
import FontAwesome as Icon
import FontAwesome.Brands as Icon
import FontAwesome.Solid as Icon
import FontAwesome.Styles as Icon
import Html exposing (Html, a, button, div, form, h1, img, input, main_, p, span, text)
import Html.Attributes as Attr
import Html.Events exposing (onInput, onSubmit)
import Messages exposing (Msg(..))
import Model exposing (..)



-- INIT


init : () -> ( Model, Cmd Msg )
init () =
    ( { name = ""
      , messageFromTauri = Nothing
      , error = Nothing
      }
    , Cmd.none
    )



-- MAIN


main : Program () Model Msg
main =
    Browser.element
        { init = init
        , update = update
        , subscriptions = subscriptions
        , view = view
        }



-- VIEW


view : Model -> Html Msg
view model =
    main_
        [ Aria.label "main content"
        , Attr.class "flex flex-col justify-center items-center w-full h-full font-sans text-center text-neutral bg-base-200"
        ]
        [ Icon.css
        , helloTauri model
        ]


helloTauri : Model -> Html Msg
helloTauri model =
    div
        [ Attr.class "hero min-h-screen"
        ]
        [ div
            [ Attr.class "hero-content min-h-fit "
            ]
            [ div
                [ Attr.class "max-w-md"
                ]
                [ title
                , madeWith
                , description
                , formSection model
                , responseMessage model.messageFromTauri model.error
                ]
            ]
        ]


title : Html Msg
title =
    h1
        [ Aria.label "Elm loves Tauri main title"
        , Attr.class "font-bold text-3xl flex gap-2 justify-center mb-6"
        ]
        [ text "Elm "
        , div [ Attr.class "text-red-500" ] [ Icon.view Icon.heart ]
        , text " Tauri"
        ]


madeWith : Html Msg
madeWith =
    div
        [ Aria.label "Logos with links to the respective tech websites"
        , Attr.class "flex flex-col items-center gap-4 mb-6"
        ]
        [ div
            [ Attr.class "flex flex-wrap gap-4 justify-center"
            ]
            (List.map (\logoData -> logoLinkComponent logoData) techStack)
        ]


logoLinkComponent : TechStackData -> Html Msg
logoLinkComponent logoData =
    a
        [ Aria.label <| logoData.name ++ " logo with a link to " ++ logoData.name ++ " website"
        , Attr.href logoData.url
        , Attr.target "_blank"
        , Attr.rel "noopener noreferrer"
        , Attr.title <| "Learn more about " ++ logoData.name
        ]
        [ img
            [ Aria.label <| logoData.name ++ " logo"
            , Attr.src logoData.logo
            , Attr.class "w-8 h-8"
            , Attr.class "object-contain hover:scale-110 transition-transform"
            , Attr.alt <| logoData.name ++ " logo"
            ]
            []
        ]


description : Html Msg
description =
    p [ Attr.class "text-center text-sm text-base-content/70 mb-6" ]
        [ text "Click on a logo to learn more about each framework" ]


formSection : Model -> Html Msg
formSection model =
    form
        [ Attr.class "join w-full"
        , onSubmit SubmittedForm
        ]
        [ nameInput model.name
        ]


nameInput : String -> Html Msg
nameInput currentName =
    div [ Attr.class "join w-full mb-4" ]
        [ input
            [ Attr.type_ "text"
            , Attr.placeholder "Enter a name..."
            , Attr.class "input join-item w-full !text-base-content placeholder:text-base-content/70"
            , Attr.value currentName
            , onInput ChangedName
            , Aria.required True
            ]
            []
        , button
            [ Attr.class "btn btn-neutral btn-sm join-item"
            , Attr.type_ "submit"
            , Aria.label "Send greeting to Tauri"
            ]
            [ text "Greet" ]
        ]


responseMessage : Maybe String -> Maybe String -> Html Msg
responseMessage maybeMessage maybeError =
    case maybeError of
        Just error ->
            div
                [ Aria.label "Error"
                , Attr.class "alert alert-error mt-4"
                ]
                [ div [ Attr.class "text-lg" ] [ Icon.view Icon.circleExclamation ]
                , span [] [ text error ]
                ]

        Nothing ->
            case maybeMessage of
                Just message ->
                    div
                        [ Aria.label "Greeting response"
                        , Attr.class "alert alert-success mt-4"
                        ]
                        [ div [ Attr.class "text-lg" ] [ Icon.view Icon.circleCheck ]
                        , span [] [ text message ]
                        ]

                Nothing ->
                    text ""



-- UPDATE


update : Msg -> Model -> ( Model, Cmd Msg )
update msg model =
    case msg of
        ChangedName name ->
            ( { model | name = name, error = Nothing }
            , Cmd.none
            )

        SubmittedForm ->
            if String.isEmpty (String.trim model.name) then
                ( { model | error = Just "Please enter a name" }
                , Cmd.none
                )

            else
                ( { model | error = Nothing }
                , sendToTauri { tag = "GREET", payload = model.name }
                )

        TauriResponded reply ->
            ( { model | messageFromTauri = Just reply, error = Nothing }
            , Cmd.none
            )



-- SUBSCRIPTIONS


subscriptions : Model -> Sub Msg
subscriptions _ =
    listenForGreeting TauriResponded



-- PORTS


port sendToTauri : { tag : String, payload : String } -> Cmd msg


port listenForGreeting : (String -> msg) -> Sub msg
