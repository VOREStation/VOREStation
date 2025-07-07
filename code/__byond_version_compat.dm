// These defines are from __513_compatibility.dm -- Please Sort
#define CLAMP(CLVALUE, CLMIN, CLMAX) clamp(CLVALUE, CLMIN, CLMAX)
#define TAN(x) tan(x)
#define ATAN2(x, y) arctan(x, y)
#define between(x, y, z) clamp(y, x, z)

// This file contains defines allowing targeting byond versions newer than the supported

//Update this whenever you need to take advantage of more recent byond features
#define MIN_COMPILER_VERSION 516
#define MIN_COMPILER_BUILD 1664
#if (DM_VERSION < MIN_COMPILER_VERSION || DM_BUILD < MIN_COMPILER_BUILD) && !defined(SPACEMAN_DMM) && !defined(OPENDREAM)
//Don't forget to update this part
#error Your version of BYOND is too out-of-date to compile this project. Go to https://secure.byond.com/download and update.
#error You need version 516.1664 or higher
#endif

// Keep savefile compatibilty at minimum supported level
#if DM_VERSION >= 515
/savefile/byond_version = MIN_COMPILER_VERSION
#endif

// lib call for external libraries into call_ext
#define LIBCALL call_ext

// For the record: GLOBAL_VERB_REF would be useless as verbs can't be global.

/// Call by name proc references, checks if the proc exists on either this type or as a global proc.
#define PROC_REF(X) (nameof(.proc/##X))
/// Call by name verb references, checks if the verb exists on either this type or as a global verb.
#define VERB_REF(X) (nameof(.verb/##X))

/// Call by name proc reference, checks if the proc exists on either the given type or as a global proc
#define TYPE_PROC_REF(TYPE, X) (nameof(##TYPE.proc/##X))
/// Call by name verb reference, checks if the verb exists on either the given type or as a global verb
#define TYPE_VERB_REF(TYPE, X) (nameof(##TYPE.verb/##X))

/// Call by name proc reference, checks if the proc is an existing global proc
#define GLOBAL_PROC_REF(X) (/proc/##X)
