sinatra-elasticsearch
=====================

Have a look at this minimalist Sinatra app to interact with elasticsearch, all within less than 20 lines of code.

Of course, this is a very limited use case.  Let's see if we can pass more options to elasticsearch.

First, lets start with getting our search term from the parameters

`term = params['term']`

Now allow for basic pagination.

```ruby
offset = params['offset'] || 0
per_page = params['per_page'] || 100
```

Set other parameters based on the request

`active = params['closed'] ? false : true`

Here's some light reading on all the parameters you can pass to ES.

http://www.elasticsearch.org/guide/en/elasticsearch/reference/current/query-dsl-query-string-query.html

Let's start building the search hash.  First, optional arguments for pagination

```ruby
search_params = {
    size: per_page,
    from: offset
}
```

Specify search fields:
`fields = ["name","tags","description"]`

You can boost certain fields with the carrot symbol followed by a boost factor:

`fields = ["name^2","tags","description"]`

We're going to start with a multi-match search.

```ruby
search_params[:query] = {
    query: {
        multi_match: {
            query: term,
            operator: "and",
            fields: fields
        }
    },
}
```

We can also filter the results, for example by the active param we grabbed above.

```ruby
search_params[:filter] = {
     bool: {
         must: {
             term: {
                 active: active
             }
         }
     }
 }
```

And finally, we run the query.

`results = client.search body: search_params`

Next, we'll look at fuzzy searching, auto completion and more advanced search options.