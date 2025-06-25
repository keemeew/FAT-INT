action set_param(bit<8> remainder_q, bit<8> remainder_hop, bit<8> remainder_egress) {
	eg_md.meta.remainder_q = remainder_q;
	eg_md.meta.remainder_hop = remainder_hop;
	eg_md.meta.remainder_egress = remainder_egress;	
}

#define SET_Q(i)\
action set_q##i##(){\
	hdr.fat_int_q##i##.q_id = (bit<8>) hdr.local_report_header.queue_id;\
	hdr.fat_int_q##i##.q_occupancy = (bit<24>) eg_intr_md.deq_qdepth;\
	hdr.fat_int_q##i##.switch_id = eg_md.meta.switch_id_q_##i##;\
}\

#define SET_HOP(i)\
action set_hop##i##(){\
	hdr.fat_int_hop_latency##i##.hop_latency = ( (bit<32>) eg_prsr_md.global_tstamp - hdr.local_report_header.ingress_global_tstamp);\
	hdr.fat_int_hop_latency##i##.switch_id = eg_md.meta.switch_id_h_##i##;\
}\

#define SET_EGRESS(i)\
action set_egress##i##(){\
	hdr.fat_int_egress_timestamp##i##.egress_timestamp = (bit<32>) eg_prsr_md.global_tstamp;\
	hdr.fat_int_egress_timestamp##i##.switch_id = eg_md.meta.switch_id_e_##i##;\
}\

#define INDEX_Q(i)\
action index_q##i##(){\
	hdr.fat_int_q##i##.q_id = (bit<8>) hdr.local_report_header.queue_id;\
	hdr.fat_int_q##i##.q_occupancy = (bit<24>) eg_intr_md.deq_qdepth;\
	hdr.fat_int_q##i##.switch_id = eg_md.meta.switch_id_q_##i##;\
}\

#define INDEX_HOP(i)\
action index_hop##i##(){\
	hdr.fat_int_hop_latency##i##.hop_latency = ( (bit<32>) eg_prsr_md.global_tstamp - hdr.local_report_header.ingress_global_tstamp);\
	hdr.fat_int_hop_latency##i##.switch_id = eg_md.meta.switch_id_h_##i##;\
}\

#define INDEX_EGRESS(i)\
action index_egress##i##(){\
	hdr.fat_int_egress_timestamp##i##.egress_timestamp = (bit<32>) eg_prsr_md.global_tstamp;\
	hdr.fat_int_egress_timestamp##i##.switch_id = eg_md.meta.switch_id_e_##i##;\
}\

SET_Q(1)
SET_Q(2)
SET_Q(3)
SET_Q(4)
SET_Q(5)

SET_HOP(1)
SET_HOP(2)
SET_HOP(3)

SET_EGRESS(1)

INDEX_Q(1)
INDEX_Q(2)
INDEX_Q(3)
INDEX_Q(4)
INDEX_Q(5)

INDEX_HOP(1)
INDEX_HOP(2)
INDEX_HOP(3)

INDEX_EGRESS(1)