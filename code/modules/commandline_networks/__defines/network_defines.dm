/*
  .
 ..^____/
`-. ___ )
  ||  || mh

  Network stuff. Mostly flags.
*/
//network type, bitflag.
#define NETWORK_TYPE_GENERIC 0x001
#define NETWORK_TYPE_HUMAN 0x002
//unimplemented, TODO later
#define NETWORK_TYPE_MECHA 0x004
#define NETWORK_TYPE_APC 0x008

//how many commands we can have in the queue before we "crash" the network
#define COMMAND_NETWORK_DEFAULT_MAX_CACHE 128
