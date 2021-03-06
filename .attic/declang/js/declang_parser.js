module.exports = (function(){
  /* Generated by PEG.js 0.6.1 (http://pegjs.majda.cz/). */
  
  var result = {
    /*
     * Parses the input with a generated parser. If the parsing is successfull,
     * returns a value explicitly or implicitly specified by the grammar from
     * which the parser was generated (see |PEG.buildParser|). If the parsing is
     * unsuccessful, throws |PEG.parser.SyntaxError| describing the error.
     */
    parse: function(input, startRule) {
      var parseFunctions = {
        "child": parse_child,
        "declang": parse_declang,
        "encoded": parse_encoded,
        "escaped_raw": parse_escaped_raw,
        "raw": parse_raw,
        "tag": parse_tag,
        "ws": parse_ws
      };
      
      if (startRule !== undefined) {
        if (parseFunctions[startRule] === undefined) {
          throw new Error("Invalid rule name: " + quote(startRule) + ".");
        }
      } else {
        startRule = "declang";
      }
      
      var pos = 0;
      var reportMatchFailures = true;
      var rightmostMatchFailuresPos = 0;
      var rightmostMatchFailuresExpected = [];
      var cache = {};
      
      function padLeft(input, padding, length) {
        var result = input;
        
        var padLength = length - input.length;
        for (var i = 0; i < padLength; i++) {
          result = padding + result;
        }
        
        return result;
      }
      
      function escape(ch) {
        var charCode = ch.charCodeAt(0);
        
        if (charCode <= 0xFF) {
          var escapeChar = 'x';
          var length = 2;
        } else {
          var escapeChar = 'u';
          var length = 4;
        }
        
        return '\\' + escapeChar + padLeft(charCode.toString(16).toUpperCase(), '0', length);
      }
      
      function quote(s) {
        /*
         * ECMA-262, 5th ed., 7.8.4: All characters may appear literally in a
         * string literal except for the closing quote character, backslash,
         * carriage return, line separator, paragraph separator, and line feed.
         * Any character may appear in the form of an escape sequence.
         */
        return '"' + s
          .replace(/\\/g, '\\\\')            // backslash
          .replace(/"/g, '\\"')              // closing quote character
          .replace(/\r/g, '\\r')             // carriage return
          .replace(/\n/g, '\\n')             // line feed
          .replace(/[\x80-\uFFFF]/g, escape) // non-ASCII characters
          + '"';
      }
      
      function matchFailed(failure) {
        if (pos < rightmostMatchFailuresPos) {
          return;
        }
        
        if (pos > rightmostMatchFailuresPos) {
          rightmostMatchFailuresPos = pos;
          rightmostMatchFailuresExpected = [];
        }
        
        rightmostMatchFailuresExpected.push(failure);
      }
      
      function parse_declang() {
        var cacheKey = 'declang@' + pos;
        var cachedResult = cache[cacheKey];
        if (cachedResult) {
          pos = cachedResult.nextPos;
          return cachedResult.result;
        }
        
        
        var savedPos0 = pos;
        var result8 = parse_ws();
        var result2 = result8 !== null ? result8 : '';
        if (result2 !== null) {
          var result3 = [];
          var result7 = parse_child();
          while (result7 !== null) {
            result3.push(result7);
            var result7 = parse_child();
          }
          if (result3 !== null) {
            var savedPos1 = pos;
            var savedReportMatchFailuresVar0 = reportMatchFailures;
            reportMatchFailures = false;
            if (input.length > pos) {
              var result6 = input.charAt(pos);
              pos++;
            } else {
              var result6 = null;
              if (reportMatchFailures) {
                matchFailed('any character');
              }
            }
            reportMatchFailures = savedReportMatchFailuresVar0;
            if (result6 === null) {
              var result5 = '';
            } else {
              var result5 = null;
              pos = savedPos1;
            }
            var result4 = result5 !== null ? result5 : '';
            if (result4 !== null) {
              var result1 = [result2, result3, result4];
            } else {
              var result1 = null;
              pos = savedPos0;
            }
          } else {
            var result1 = null;
            pos = savedPos0;
          }
        } else {
          var result1 = null;
          pos = savedPos0;
        }
        var result0 = result1 !== null
          ? (function(children) {return children;})(result1[1])
          : null;
        
        
        
        cache[cacheKey] = {
          nextPos: pos,
          result:  result0
        };
        return result0;
      }
      
      function parse_child() {
        var cacheKey = 'child@' + pos;
        var cachedResult = cache[cacheKey];
        if (cachedResult) {
          pos = cachedResult.nextPos;
          return cachedResult.result;
        }
        
        
        var savedPos0 = pos;
        var result7 = parse_raw();
        if (result7 !== null) {
          var result2 = result7;
        } else {
          var result6 = parse_encoded();
          if (result6 !== null) {
            var result2 = result6;
          } else {
            var result5 = parse_tag();
            if (result5 !== null) {
              var result2 = result5;
            } else {
              var result2 = null;;
            };
          };
        }
        if (result2 !== null) {
          var result4 = parse_ws();
          var result3 = result4 !== null ? result4 : '';
          if (result3 !== null) {
            var result1 = [result2, result3];
          } else {
            var result1 = null;
            pos = savedPos0;
          }
        } else {
          var result1 = null;
          pos = savedPos0;
        }
        var result0 = result1 !== null
          ? (function(ch) {return ch;})(result1[0])
          : null;
        
        
        
        cache[cacheKey] = {
          nextPos: pos,
          result:  result0
        };
        return result0;
      }
      
      function parse_tag() {
        var cacheKey = 'tag@' + pos;
        var cachedResult = cache[cacheKey];
        if (cachedResult) {
          pos = cachedResult.nextPos;
          return cachedResult.result;
        }
        
        
        if (input.substr(pos, 3) === "tag") {
          var result0 = "tag";
          pos += 3;
        } else {
          var result0 = null;
          if (reportMatchFailures) {
            matchFailed("\"tag\"");
          }
        }
        
        
        
        cache[cacheKey] = {
          nextPos: pos,
          result:  result0
        };
        return result0;
      }
      
      function parse_encoded() {
        var cacheKey = 'encoded@' + pos;
        var cachedResult = cache[cacheKey];
        if (cachedResult) {
          pos = cachedResult.nextPos;
          return cachedResult.result;
        }
        
        
        if (input.substr(pos, 7) === "encoded") {
          var result0 = "encoded";
          pos += 7;
        } else {
          var result0 = null;
          if (reportMatchFailures) {
            matchFailed("\"encoded\"");
          }
        }
        
        
        
        cache[cacheKey] = {
          nextPos: pos,
          result:  result0
        };
        return result0;
      }
      
      function parse_raw() {
        var cacheKey = 'raw@' + pos;
        var cachedResult = cache[cacheKey];
        if (cachedResult) {
          pos = cachedResult.nextPos;
          return cachedResult.result;
        }
        
        
        var savedPos0 = pos;
        if (input.substr(pos, 1) === "`") {
          var result2 = "`";
          pos += 1;
        } else {
          var result2 = null;
          if (reportMatchFailures) {
            matchFailed("\"`\"");
          }
        }
        if (result2 !== null) {
          var result3 = [];
          var result11 = parse_escaped_raw();
          if (result11 !== null) {
            var result5 = result11;
          } else {
            var savedPos1 = pos;
            var savedPos2 = pos;
            var savedReportMatchFailuresVar0 = reportMatchFailures;
            reportMatchFailures = false;
            if (input.substr(pos, 1) === "`") {
              var result10 = "`";
              pos += 1;
            } else {
              var result10 = null;
              if (reportMatchFailures) {
                matchFailed("\"`\"");
              }
            }
            reportMatchFailures = savedReportMatchFailuresVar0;
            if (result10 === null) {
              var result8 = '';
            } else {
              var result8 = null;
              pos = savedPos2;
            }
            if (result8 !== null) {
              if (input.length > pos) {
                var result9 = input.charAt(pos);
                pos++;
              } else {
                var result9 = null;
                if (reportMatchFailures) {
                  matchFailed('any character');
                }
              }
              if (result9 !== null) {
                var result7 = [result8, result9];
              } else {
                var result7 = null;
                pos = savedPos1;
              }
            } else {
              var result7 = null;
              pos = savedPos1;
            }
            var result6 = result7 !== null
              ? (function(txt) {return txt;})(result7[1])
              : null;
            if (result6 !== null) {
              var result5 = result6;
            } else {
              var result5 = null;;
            };
          }
          while (result5 !== null) {
            result3.push(result5);
            var result11 = parse_escaped_raw();
            if (result11 !== null) {
              var result5 = result11;
            } else {
              var savedPos1 = pos;
              var savedPos2 = pos;
              var savedReportMatchFailuresVar0 = reportMatchFailures;
              reportMatchFailures = false;
              if (input.substr(pos, 1) === "`") {
                var result10 = "`";
                pos += 1;
              } else {
                var result10 = null;
                if (reportMatchFailures) {
                  matchFailed("\"`\"");
                }
              }
              reportMatchFailures = savedReportMatchFailuresVar0;
              if (result10 === null) {
                var result8 = '';
              } else {
                var result8 = null;
                pos = savedPos2;
              }
              if (result8 !== null) {
                if (input.length > pos) {
                  var result9 = input.charAt(pos);
                  pos++;
                } else {
                  var result9 = null;
                  if (reportMatchFailures) {
                    matchFailed('any character');
                  }
                }
                if (result9 !== null) {
                  var result7 = [result8, result9];
                } else {
                  var result7 = null;
                  pos = savedPos1;
                }
              } else {
                var result7 = null;
                pos = savedPos1;
              }
              var result6 = result7 !== null
                ? (function(txt) {return txt;})(result7[1])
                : null;
              if (result6 !== null) {
                var result5 = result6;
              } else {
                var result5 = null;;
              };
            }
          }
          if (result3 !== null) {
            if (input.substr(pos, 1) === "`") {
              var result4 = "`";
              pos += 1;
            } else {
              var result4 = null;
              if (reportMatchFailures) {
                matchFailed("\"`\"");
              }
            }
            if (result4 !== null) {
              var result1 = [result2, result3, result4];
            } else {
              var result1 = null;
              pos = savedPos0;
            }
          } else {
            var result1 = null;
            pos = savedPos0;
          }
        } else {
          var result1 = null;
          pos = savedPos0;
        }
        var result0 = result1 !== null
          ? (function(txt) {return txt.join('');})(result1[1])
          : null;
        
        
        
        cache[cacheKey] = {
          nextPos: pos,
          result:  result0
        };
        return result0;
      }
      
      function parse_escaped_raw() {
        var cacheKey = 'escaped_raw@' + pos;
        var cachedResult = cache[cacheKey];
        if (cachedResult) {
          pos = cachedResult.nextPos;
          return cachedResult.result;
        }
        
        
        if (input.substr(pos, 2) === "\\`") {
          var result1 = "\\`";
          pos += 2;
        } else {
          var result1 = null;
          if (reportMatchFailures) {
            matchFailed("\"\\\\`\"");
          }
        }
        var result0 = result1 !== null
          ? (function() {return '`';})()
          : null;
        
        
        
        cache[cacheKey] = {
          nextPos: pos,
          result:  result0
        };
        return result0;
      }
      
      function parse_ws() {
        var cacheKey = 'ws@' + pos;
        var cachedResult = cache[cacheKey];
        if (cachedResult) {
          pos = cachedResult.nextPos;
          return cachedResult.result;
        }
        
        
        if (input.substr(pos).match(/^[ 	\r\n]/) !== null) {
          var result1 = input.charAt(pos);
          pos++;
        } else {
          var result1 = null;
          if (reportMatchFailures) {
            matchFailed("[ 	\\r\\n]");
          }
        }
        if (result1 !== null) {
          var result0 = [];
          while (result1 !== null) {
            result0.push(result1);
            if (input.substr(pos).match(/^[ 	\r\n]/) !== null) {
              var result1 = input.charAt(pos);
              pos++;
            } else {
              var result1 = null;
              if (reportMatchFailures) {
                matchFailed("[ 	\\r\\n]");
              }
            }
          }
        } else {
          var result0 = null;
        }
        
        
        
        cache[cacheKey] = {
          nextPos: pos,
          result:  result0
        };
        return result0;
      }
      
      function buildErrorMessage() {
        function buildExpected(failuresExpected) {
          failuresExpected.sort();
          
          var lastFailure = null;
          var failuresExpectedUnique = [];
          for (var i = 0; i < failuresExpected.length; i++) {
            if (failuresExpected[i] !== lastFailure) {
              failuresExpectedUnique.push(failuresExpected[i]);
              lastFailure = failuresExpected[i];
            }
          }
          
          switch (failuresExpectedUnique.length) {
            case 0:
              return 'end of input';
            case 1:
              return failuresExpectedUnique[0];
            default:
              return failuresExpectedUnique.slice(0, failuresExpectedUnique.length - 1).join(', ')
                + ' or '
                + failuresExpectedUnique[failuresExpectedUnique.length - 1];
          }
        }
        
        var expected = buildExpected(rightmostMatchFailuresExpected);
        var actualPos = Math.max(pos, rightmostMatchFailuresPos);
        var actual = actualPos < input.length
          ? quote(input.charAt(actualPos))
          : 'end of input';
        
        return 'Expected ' + expected + ' but ' + actual + ' found.';
      }
      
      function computeErrorPosition() {
        /*
         * The first idea was to use |String.split| to break the input up to the
         * error position along newlines and derive the line and column from
         * there. However IE's |split| implementation is so broken that it was
         * enough to prevent it.
         */
        
        var line = 1;
        var column = 1;
        var seenCR = false;
        
        for (var i = 0; i <  rightmostMatchFailuresPos; i++) {
          var ch = input.charAt(i);
          if (ch === '\n') {
            if (!seenCR) { line++; }
            column = 1;
            seenCR = false;
          } else if (ch === '\r' | ch === '\u2028' || ch === '\u2029') {
            line++;
            column = 1;
            seenCR = true;
          } else {
            column++;
            seenCR = false;
          }
        }
        
        return { line: line, column: column };
      }
      
      
      
      var result = parseFunctions[startRule]();
      
      /*
       * The parser is now in one of the following three states:
       *
       * 1. The parser successfully parsed the whole input.
       *
       *    - |result !== null|
       *    - |pos === input.length|
       *    - |rightmostMatchFailuresExpected| may or may not contain something
       *
       * 2. The parser successfully parsed only a part of the input.
       *
       *    - |result !== null|
       *    - |pos < input.length|
       *    - |rightmostMatchFailuresExpected| may or may not contain something
       *
       * 3. The parser did not successfully parse any part of the input.
       *
       *   - |result === null|
       *   - |pos === 0|
       *   - |rightmostMatchFailuresExpected| contains at least one failure
       *
       * All code following this comment (including called functions) must
       * handle these states.
       */
      if (result === null || pos !== input.length) {
        var errorPosition = computeErrorPosition();
        throw new this.SyntaxError(
          buildErrorMessage(),
          errorPosition.line,
          errorPosition.column
        );
      }
      
      return result;
    },
    
    /* Returns the parser source code. */
    toSource: function() { return this._source; }
  };
  
  /* Thrown when a parser encounters a syntax error. */
  
  result.SyntaxError = function(message, line, column) {
    this.name = 'SyntaxError';
    this.message = message;
    this.line = line;
    this.column = column;
  };
  
  result.SyntaxError.prototype = Error.prototype;
  
  return result;
})();
