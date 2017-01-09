% TXL 7.7a4 Translation, Turing to C
% Andy Maloney, Queen's University, January 1995
% [part of CISC 499 undergraduate thesis project]

% The base C grammar
include "C.Grm"

% Comment out this line to disallow Gnu gcc extensions
include "CGnuOverrides.Grm"

% Comment out this line to disallow parsing of comments
include "CCommentOverrides.Grm"

% My extra string functions ( [before] and [after] )
include "StringUtils.Rul"

% Translation grammar overrides, to make translations convenient
include "CtoDartOverrides.Grm"

% Translation rule sets
include "TranslateDecls.Rul"
include "TranslateStatements.Rul"
include "TranslateFunctions.Rul"
include "TranslateExpressions.Rul"
include "OptimizeTranslatedDart.Rul"

% Main translation rule set

function main
    replace [program]
	ExtDefs [repeat C_compilation_unit]

    construct TuringProgram [repeat C_compilation_unit]
	_ [changeExternalDef each ExtDefs]

    construct NewTuringProgram [repeat C_compilation_unit]
	TuringProgram [moveMain] 
		      [stripMainFunctionHeader]
    by
	NewTuringProgram [optimizeTuring]
	
end function


function changeExternalDef ExtDef [C_compilation_unit]
    replace [repeat C_compilation_unit]
	SoFar [repeat C_compilation_unit]
	
    construct NewExtDef [C_compilation_unit]
	ExtDef [translateCConst]
	       [translateCType]
	       [translateCVar]
	       [translateCFunction]
    by
	SoFar [. NewExtDef]
end function


%% move the 'main' function to the end of the function block
function moveMain
    replace * [repeat C_compilation_unit]
	'function 'main ': TS [type_specifier]
		D [repeat C_compilation_unit]
		S [repeat statement]
	'end 'main
	Rest [repeat C_compilation_unit]

    construct NewMain [C_compilation_unit]
	'function 'main ': TS
		D
		S
	'end 'main
    by
	Rest [. NewMain]
end function

%% remove the function header from the main function
function stripMainFunctionHeader
    replace * [C_compilation_unit]
	'function 'main ': TS [type_specifier]
		D [repeat C_compilation_unit]
		S [repeat statement]
	'end 'main

    construct Comment [comment]
        _ [+ "% Main function"]
    by
	Comment
	D
	S
end function
