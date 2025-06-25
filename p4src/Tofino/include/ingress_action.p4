action int_set_source () {
	ig_md.meta.source = 1;
}	

action valid_space(bit<8> case) {
	hdr.fat_int_case.setValid();
	hdr.fat_int_space.setValid();

	hdr.fat_int_case.case = case;
	hdr.ipv4.dscp = INT;
}

action set_switch_id(bit<8> switch_id){
	ig_md.meta.switch_id_q_1 = switch_id;
	ig_md.meta.switch_id_q_2 = switch_id;
	ig_md.meta.switch_id_q_3 = switch_id;
	ig_md.meta.switch_id_q_4 = switch_id;
	ig_md.meta.switch_id_q_5 = switch_id;

	ig_md.meta.switch_id_h_1 = switch_id;
	ig_md.meta.switch_id_h_2 = switch_id;
	ig_md.meta.switch_id_h_3 = switch_id;
	
	ig_md.meta.switch_id_e_1 = switch_id;
}

action set_space(bit<8> queue_space, bit<8> hop_space, bit<8> egress_space){
	ig_md.meta.sampling_space_q = queue_space;
	ig_md.meta.sampling_space_hop = hop_space;
	ig_md.meta.sampling_space_egress_tst = egress_space;
}

action set_egress_port(bit<9> egress_spec) {
	ig_tm_md.ucast_egress_port = egress_spec;
	hdr.ipv4.ttl=hdr.ipv4.ttl-1;
}

#define VALID_SPACE_Q(i)\
action valid_space_q##i##(){\
	hdr.fat_int_q##i##.setValid();\
	ig_md.meta.count_q = 1;\
	hdr.fat_int_space.queue_space = hdr.fat_int_space.queue_space + 1;\
}\

#define VALID_SPACE_HOP(i)\
action valid_space_hop##i##(){\
	hdr.fat_int_hop_latency##i##.setValid();\
	ig_md.meta.count_hop = 1;\
	hdr.fat_int_space.hop_space = hdr.fat_int_space.hop_space + 1;\
}\

#define VALID_SPACE_EGRESS(i)\
action valid_space_egress##i##(){\
	hdr.fat_int_egress_timestamp##i##.setValid();\
	ig_md.meta.count_egress = 1;\
	hdr.fat_int_space.egress_space = hdr.fat_int_space.egress_space + 1;\
}\

action set_local_hdr() {
	hdr.local_report_header.setValid();
	hdr.local_report_header.ingress_port_id = (bit<16>) ig_intr_md.ingress_port;
	hdr.local_report_header.queue_id = (bit<8>) ig_tm_md.qid;
	hdr.local_report_header.ingress_global_tstamp = (bit<32>) ig_intr_md.ingress_mac_tstamp;
}

VALID_SPACE_Q(1)
VALID_SPACE_Q(2)
VALID_SPACE_Q(3)
VALID_SPACE_Q(4)
VALID_SPACE_Q(5)

VALID_SPACE_HOP(1)
VALID_SPACE_HOP(2)
VALID_SPACE_HOP(3)

VALID_SPACE_EGRESS(1)