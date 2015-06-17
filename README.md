# Dasic - Dart BASIC interpreter

Dasic is a complete standalone
interpreter for a dialect of the original BASIC language. It handles tokenizing, parsing, interpreting, output,
variables, expressions, and flow control, like a full-scale compiler or
interpreter, just in miniature. I tried to keep the code simple and readable
while still being terse.

If you've ever wanted a gentle introduction to how programming languages work
under the hood, Dasic is a good place to start.

# Sample
Result of `dasic packages/dasic/scripts/mandel.das`

```shell
                                                ----------
                                          ---------++*+++-------
                                      -------------+++*=*=++-------
                                  ---------------++*==@@@=+++---------
                               -------------++++++=*@@@@@@@+++---------
                            ------------+++++++++===@@@@@@==++++++++++---
                         ------------+++**@@@=*@@@@@@@@@@@@@@@@===*====---
                     -------------++++++==*@@@@@@@@@@@@@@@@@@@@@@@@@*+++---
               -----++++++++++++++++++=@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@+++----
        -----------++=====+=*=+++++++*@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@*+----
    --------------+++++=@@@@@@@@*@===@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@=++-----
  -------------++++++=@@@@@@@@@@@@@@*@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@*+------
 ------++++++++++=*@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@+++------
 --++++=+++=+++@=*@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@=++++------
 ---------+++++++=====@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@=++------
   --------------++++===@@@@@@@@@@@==@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@++-----
     -------------++++==@*==*@=@==+==@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@*=++----
           --------+++=+++++=++++++++=@*@@@@@@@@@@@@@@@@@@@@@@@@@@@@@==*+----
                  --------------++++++=@=@@@@@@@@@@@@@@@@@@@@@@@@@@*=+++----
                       ------------++++++=@@@@@@@@@@@@@@@@@@@@@@*@@@@=+----
                           -----------++=@*==+=@@@**@@@@@@*=*=@=++++==+---
                              ------------++++++++=@@@@@@@@++++++-------
                                 --------------+++*@*@@@*=@++----------
                                    --------------++++=@=+++---------
                                        -----------++==++++-------
                                             -------=+--------
```

# Install
If you don't have Dart on your machine - Download and install it from [here][installdart]

Install Dasic
```shell
    pub global activate dasic
```

Update Dasic
```shell
    # activate dasic again
    pub global activate dasic
```

Uninstall Dasic
```shell
    pub global deactivate dasic   
```    

## Usage

Try
```bash

    dasic packages/dasic/scripts/hello.das
    dasic packages/dasic/scripts/hellos.das
    dasic packages/dasic/scripts/mandel.das
```

## More Info

The real information about Dasic, including the language syntax and how the
interpreter works is all in with the code, so go ahead and read through
Dasi.

If you have any questions, feel free to get in touch. Cheers!

### Features and bugs
Please file feature requests and bugs at the [issue tracker][tracker].

### Thanks
I want to thank "Bob Nystrom" for his base-work "JASIC"! You can read more from Bob and 
about "A Complete Interpreter in One Java File" [here][bob] on his Blog.  
Java-Version of Dasic is [Jasic][jasic] 

### License

    Copyright 2015 Michael Mitterer (office@mikemitterer.at),
    IT-Consulting and Development Limited, Austrian Branch

    Licensed under the Apache License, Version 2.0 (the "License");
    you may not use this file except in compliance with the License.
    You may obtain a copy of the License at

       http://www.apache.org/licenses/LICENSE-2.0

    Unless required by applicable law or agreed to in writing,
    software distributed under the License is distributed on an
    "AS IS" BASIS, WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND,
    either express or implied. See the License for the specific language
    governing permissions and limitations under the License.
    

[installdart]: https://www.dartlang.org/downloads/
[tracker]: https://github.com/MikeMitterer/dart-dasic/issues
[jasic]: https://github.com/munificent/jasic
[bob]: http://journal.stuffwithstuff.com/2010/07/18/jasic-a-complete-interpreter-in-one-java-file/