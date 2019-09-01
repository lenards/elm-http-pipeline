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
> type Msg = Ignored (Result Http.Error ())
> Get "http://httpbin.org/get" \
|   |> create \
|   |> addHeaders [] \
|   |> setBody Http.emptyBody \
|   |> expectedResponse (Http.expectWhatever Ignored) \
|   |> build
{ body = <internals>, expect = <internals>, headers = [], method = "GET", timeout = Nothing, tracker = Nothing, url = "http://httpbin.org/get" }
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
    , url : String
    , headers : List Header
    , body : Body
    , expect : Expect msg
    , timeout : Maybe Float
    , tracker : Maybe String
    }

type Partial a = Partial a

type alias R2 msg =
    String -> (List Header) -> Body -> (Expect msg) -> (Maybe Float) -> (Maybe String) -> Request msg

type alias R3 msg =
    (List Header) ->  Body -> (Expect msg) -> (Maybe Float) -> (Maybe String) -> Request msg

type alias R4 msg =
    Body -> (Expect msg) -> (Maybe Float) -> (Maybe String) -> Request msg

type alias R5 msg =
    (Expect msg) -> (Maybe Float) -> (Maybe String) -> Request msg

type alias R6 msg =
    (Maybe Float) -> (Maybe String) -> Request msg

create : HttpMethod -> Partial (R3 msg)
create method =
    case method of
        Get url ->
            Partial (Request "GET" url)
        Head url ->
            Partial (Request "HEAD" url)
        Post url ->
            Partial (Request "POST" url)
        Put url ->
            Partial (Request "PUT" url)
        Delete url ->
            Partial (Request "DELETE" url)
        Options url ->
            Partial (Request "OPTIONS" url)
        Patch url ->
            Partial (Request "PATCH" url)


addHeaders : List Header -> Partial (R3 msg) -> Partial (R4 msg)
addHeaders headers (Partial f)  =
    Partial (f headers)

setBody : Body -> Partial (R4 msg) -> Partial (R5 msg)
setBody b (Partial f) =
    Partial (f b)

expectedResponse : Expect msg -> Partial (R5 msg) -> Partial (R6 msg)
expectedResponse expected (Partial f) =
    Partial (f expected)

build : Partial (R6 msg) -> Request msg
build (Partial f) =
    f Nothing Nothing

{-| Cannot make the **leap* to something generalized _yet_

this is just something that compiles ...
-}
set : a -> (a -> b) -> Partial b
set val p =
    Partial (p val)

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
