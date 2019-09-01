module Http.Pipeline exposing (..)

import Http exposing (Header, Body, Expect)


{-| HTTP Methods defined as a custom type

This omits `TRACE` and `CONNECT` from the possible methods.

See also https://developer.mozilla.org/en-US/docs/Web/HTTP/Methods

A possible example:

```
---- Elm 0.19.0 ----------------------------------------------------------------
Read <https://elm-lang.org/0.19.0/repl> to learn more: exit, help, imports, etc.
--------------------------------------------------------------------------------
> import Http
> import Http.Pipeline exposing (..)
> Get "http://httpbin.org/get-values" \
|   |> addHeaders [] \
|   |> setBody Http.emptyBody \
|
<function> : R5 msg
> type Msg = Ignored (Result Http.Error ())
> Get "http://httpbin.org/get-values" \
|   |> addHeaders [] \
|   |> setBody Http.emptyBody \
|   |> expectedResponse (Http.expectWhatever Ignored) \
|   |> build
{ body = <internals>, expect = <internals>, headers = [], method = "GET", timeout = Nothing, tracker = Nothing, url = "http://httpbin.org/get-values" }
    : Request Msg
```
-}
type HttpMethod 
    = Get String
    | Head String
    | Post String
    | Put String
    | Delete String
    | Options String
    | Patch String

type Method
    = Method HttpMethod

type Headers
    = Headers (List Header)

type RequestUrl
    = Url_ String

type RequestBody
    = Body_ Body

type ExpectedResponse msg
    = Expect_ (Expect msg)

type alias Request msg =
    { method : String
    , headers : List Header
    , url : String
    , body : Body
    , expect : Expect msg
    , timeout : Maybe Float
    , tracker : Maybe String
    }


type alias R2 msg =
    (List Header) -> String -> Body -> (Expect msg) -> (Maybe Float) -> (Maybe String) -> Request msg 

type alias R3 msg =
    String -> Body -> (Expect msg) -> (Maybe Float) -> (Maybe String) -> Request msg 

type alias R4 msg =
    Body -> (Expect msg) -> (Maybe Float) -> (Maybe String) -> Request msg 

type alias R5 msg =
    (Expect msg) -> (Maybe Float) -> (Maybe String) -> Request msg 

type alias R6 msg =
    (Maybe Float) -> (Maybe String) -> Request msg 

addHeaders : List Header -> HttpMethod -> R4 msg 
addHeaders headers method  =
    case method of
        Get url ->
            (Request "GET" headers url)
        Head url ->
            (Request "HEAD" headers url)
        Post url ->
            (Request "POST" headers url)
        Put url ->
            (Request "PUT" headers url)
        Delete url ->
            (Request "DELETE" headers url)
        Options url ->
            (Request "OPTIONS" headers url)
        Patch url ->
            (Request "PATCH" headers url)

setBody : Body -> R4 msg -> R5 msg
setBody b f =
    (f b)

expectedResponse : Expect msg -> R5 msg -> R6 msg
expectedResponse expected f =
    (f expected)

build : R6 msg -> Request msg
build f =
    f Nothing Nothing

-- Conversion

fromMethod : HttpMethod -> String
fromMethod method =
    case method of
        Get _ ->
            "GET"
        Head _ ->
            "HEAD"
        Post _ ->
            "POST"
        Put _ ->
            "PUT"
        Delete _ ->
            "DELETE"
        Options _ ->
            "OPTIONS"
        Patch _ ->
            "PATCH"
