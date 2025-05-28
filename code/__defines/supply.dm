// Supply shuttle status defines
#define SUP_SHUTTLE_ERROR -1	// Error state
#define SUP_SHUTTLE_DOCKED 0
#define SUP_SHUTTLE_UNDOCKED 1
#define SUP_SHUTTLE_DOCKING 2
#define SUP_SHUTTLE_UNDOCKING 3
#define SUP_SHUTTLE_TRANSIT 4
#define SUP_SHUTTLE_AWAY 5

// Supply computer access levels
#define SUP_SEND_SHUTTLE 0x1 // Send the shuttle back and forth
#define SUP_ACCEPT_ORDERS 0x2 // Accept orders
#define SUP_CONTRABAND	  0x4 // Able to order contraband supply packs

// Supply_order status values
#define SUP_ORDER_REQUESTED "Requested"
#define SUP_ORDER_APPROVED  "Approved"
#define SUP_ORDER_DENIED    "Denied"
#define SUP_ORDER_SHIPPED   "Shipped"
