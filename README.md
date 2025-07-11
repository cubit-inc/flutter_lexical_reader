
# Flutter Lexical Reader

The Flutter Lexical Reader is a package designed to efficiently read and process lexical markup within Flutter applications.


## Features

- Easy-to-use API for parsing lexical markup.
- Integration with Flutter widgets for seamless rendering.
- Lightweight and optimized for performance.
## Getting started

### Prerequisites

- Ensure you have Flutter and Dart set up on your machine.

### Installation

    Add `flutter_lexical_reader` to your `pubspec.yaml` file:
   ```yaml
   dependencies:
     flutter_lexical_reader: latest_version


   ## Usage

   import 'package:flutter_lexical_reader/flutter_lexical_reader.dart';

   // Use the parser...
   const exampleMarkup = '...';  // Your lexical markup here
   final parsedData = LexicalParser.parse(exampleMarkup);

```

### Custom Error Widget

```dart
    LexicalParser(
        shrinkWrap: true,
        fontFamily: font, // add font to globally set the font of the parser
        globalContext: globalContext, // use global context incase of nested route screen
        errorWidget: ErrorWidget(), // add a widget incase of parse failure        
        sourceMap: sourceMap,
        nodeTransformers: NodeTransformers(transformers: [
            Transformer(
                type: "image",
                transformerWidget: (Map<String, dynamic> childElement, BuildContext context) {
                    CachedNetworkImage(
                        // your transformer code here
                    )
                })
            ]), //Map of node transformer
        
    ),
```

## Additional information

You can further modify this to include any specific instructions, features or nuances about your package.

