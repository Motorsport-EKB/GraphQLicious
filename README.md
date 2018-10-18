# GraphQLicious

GraphQLicious is a swift component that provides an intuitive and convenient way to build GraphQL queries and convert them easily to String representations.

[![Platform](https://img.shields.io/cocoapods/p/GraphQLicious.svg?style=flat)](https://github.com/WeltN24/GraphQLicious)
[![carthage](https://img.shields.io/badge/Carthage-compatible-4BC51D.svg)](https://github.com/Carthage/Carthage)
[![cocoapods](https://img.shields.io/cocoapods/v/GraphQLicious.svg)](http://cocoapods.org/pods/GraphQLicious)
[![Swift](https://img.shields.io/badge/Swift-4.2-orange.svg)](https://swift.org)
[![license](https://img.shields.io/cocoapods/l/GraphQLicious.svg)](http://cocoapods.org/pods/GraphQLicious)
[![travis](http://img.shields.io/travis/WeltN24/GraphQLicious.svg)](https://travis-ci.org/WeltN24/GraphQLicious)
[![codebeat](https://codebeat.co/badges/44501d73-aea0-42ad-8206-0466c4bb26b3)](https://codebeat.co/projects/github-com-weltn24-graphqlicious)
[![codecov](https://codecov.io/gh/WeltN24/GraphQLicious/branch/master/graph/badge.svg)](https://codecov.io/gh/WeltN24/GraphQLicious)

# Contents

- [Installation](#installation)
- [Usage](#usage)
- [Authors](#authors)
- [License](#license)

## Installation

### CocoaPods

`GraphQLicious` is available through CocoaPods. To install it, simply add the following line to your Podfile

```bash
pod "GraphQLicious" :git => "https://github.com/omaralbeik/GraphQLicious.git"
```

## Usage

### Query

Let's assume, we have the id of an article and we want to have the `headline`, `body` text and `opener image` of that article.

Our graphQL query for that will look like this:

```graphQL
query {
	test: content(id: 153082687){
		...contentFields
	}
}
fragment contentFields on Content {
	headline,
	body,
	image(role: "opener", enum: [this, that]){
		...imageContent
	}
}
fragment imageContent on Image {
	id
	url
}
fragment urlFragment on Image {
	 url (ratio: 1, size: 200)
}

```

First, let's create a `Fragment` to fetch the contents of an image, namely the image `id` and the image `url`

```swift
let imageContent = Fragment(
	withAlias: "imageContent",
	name: "Image",
	fields: [
		"id",
		"url"
	]
)
```

Next, let's embed the `Fragment` into a `Request` that gets the opener image.
**Note:** `Argument` values that are of type `String` are automatically represented with quotes.
**GraphQL** also gives us the possibility to have custom enums as argument values. All you have to do is letting your enum implement `ArgumentValue` and you're good to go.

```swift
enum customEnum: String, ArgumentValue {
  case This = "this"
  case That = "that"

  private var asGraphQLArgument: String {
    return rawValue // without quotes
  }
}

let customEnumArgument = Argument(
  key: "enum",
  values: [
    customEnum.This,
    customEnum.That
  ]
)
```

```swift
let imageContentRequest = Request(
	name: "image",
	arguments: [
		Argument(key: "role", value: "opener"),
		customEnumArgument
	],
	fields: [
		imageContent
	]
)
```

So now we have a Request with an embedded Fragment. Let's go one step further.
If we want to, we can imbed that Request into another Fragment. (We can also embed Fragments into Fragments)
Additionally to the opener image with its id and url we also want the `headline` and `body` text of the article.

```swift
let articleContent = Fragment(
	withAlias: "contentFields",
	name: "Content",
	fields: [
		"headline",
		"body",
		imageContentRequest
	]
)
```

Finally, we put everything together as a `Query`. A Query always has a top level Request to get everything started, and requires all the Fragments that are used inside.

```swift
let query = Query(request: Request(
	withAlias: "test",
	name: "content",
	arguments: [
		Argument(key: "id", values: [153082687])
	],
	fields: [
		articleContent
	]),
	fragments: [articleContent, imageContent]
)
```

All we have to do now is to call `create()` on our Query and we're good to go.

```swift
print(query.create())
```

### Mutation

Let's assume, we want to change our username and our age in our backend and we want to have the new name and age back to make sure everything went right.

Let's assume further, our server provides a mutating method `editMe` for exactly that purpose.

Our graphQL query for that will look like this:

```graphQL
mutation myMutation {
	editMe(
		name: "joe",
		age: 99
	)
	{
		name,
		age
	}
}
```
Let us first create the actual mutating function. We can use a `Request` for that. As `Argument` `values` we give information about which fields should be changed and what's the actual change

```swift
let mutatingRequest = Request(
      name: "editMe",
      arguments: [
      	Argument(name: "name", value: "joe"),
        Argument(name: "age", value: 99)
      ],
      fields: [
        "name",
        "age"
      ]
    )
```

Finally, we put everything together as a `Mutation`.

`Mutation`s work just like `Queries`

```swift
let mutation = Mutation(
	withAlias: "myMutation",
	mutatingRequest: mutatingRequest
)
```

After we've done that we can create the request.

```swift
print(mutation.create())
```

## Authors

`GraphQLicious` was made in-house by WeltN24 and Updated Swift 3.2 by omaralbeik

## License

`GraphQLicious` is available under the MIT license. See the LICENSE files for more info.
