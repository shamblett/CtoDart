% TXL 7.7a4 Translation, Turing to C
% Andy Maloney, Queen's University, January 1995
% [part of CISC 499 undergraduate thesis project]

% The base C grammar
include "C.Grm"

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
	ExtDefs [repeat externaldefinition]

    construct TuringProgram [repeat externaldefinition]
	_ [changeExternalDef each ExtDefs]

    construct NewTuringProgram [repeat externaldefinition]
	TuringProgram [moveMain] 
		      [stripMainFunctionHeader]
    by
	NewTuringProgram [optimizeTuring]
	
end function


function changeExternalDef ExtDef [externaldefinition]
    replace [repeat externaldefinition]
	SoFar [repeat externaldefinition]
	
    construct NewExtDef [externaldefinition]
	ExtDef [translateCConst]
	       [translateCType]
	       [translateCVar]
	       [translateCFunction]
    by
	SoFar [. NewExtDef]
end function


%% move the 'main' function to the end of the function block
function moveMain
    replace * [repeat externaldefinition]
	'function 'main ': TS [type_specifier]
		D [repeat externaldefinition]
		S [repeat statement]
	'end 'main
	Rest [repeat externaldefinition]

    construct NewMain [externaldefinition]
	'function 'main ': TS
		D
		S
	'end 'main
    by
	Rest [. NewMain]
end function

%% remove the function header from the main function
function stripMainFunctionHeader
    replace * [externaldefinition]
	'function 'main ': TS [type_specifier]
		D [repeat externaldefinition]
		S [repeat statement]
	'end 'main

    construct Comment [comment]
        _ [+ "% Main function"]
    by
	Comment
	D
	S
end function
