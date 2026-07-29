module Model exposing (..)


type alias Model =
    { name : String
    , messageFromTauri : Maybe String
    , error : Maybe String
    }


type alias Name =
    String


type alias Logo =
    String


type alias Url =
    String


type alias TechStackData =
    { name : Name
    , url : Url
    , logo : Logo
    }


techStack : List TechStackData
techStack =
    [ { name = "Elm"
      , url = "https://elm-lang.org"
      , logo = "/assets/stack/elm.svg"
      }
    , { name = "Tailwind CSS"
      , url = "https://tailwindcss.com"
      , logo = "/assets/stack/tailwind.svg"
      }
    , { name = "Daisy UI"
      , url = "https://daisyui.com"
      , logo = "/assets/stack/daisyui.svg"
      }
    , { name = "PNPM"
      , url = "https://pnpm.io"
      , logo = "/assets/stack/pnpm.svg"
      }
    , { name = "Vite JS"
      , url = "https://vite.dev"
      , logo = "/assets/stack/vite.svg"
      }
    , { name = "Tauri"
      , url = "https://tauri.app"
      , logo = "/assets/stack/tauri.svg"
      }
    ]
