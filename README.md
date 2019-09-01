# elm-http-pipeline
A library for building HTTP requests using the pipeline (`|>`) operation and plain function calls.

## Context

I enjoy using `Json.Decode.Pipeline` and when looking at Alex Korban's ["How JSON Decode Pipeline Chaining Works"](https://korban.net/posts/elm/2018-07-10-how-json-decode-pipeline-chaining-works/?__s=4wkzui9hudcqgabdzvw2). In seeing how the `required` and `optional` function work, I was curious if I might be able to do that for another "records" (aka `type alias Blah`).

I am not sure what I am doing here is a _good_ idea (**at all**). In other words, "here _might_ be **slow** monsters".

## Testing

I am hoping to put this to use in testing the requests created:
- https://package.elm-lang.org/packages/avh4/elm-program-test/3.0.0/
