header ethernet_t {
	bit<48> dstAddr;
	bit<48> srcAddr;
	bit<16> etherType;
}

header ipv4_t {
	bit<4>  version;
	bit<4>  ihl;
	bit<8> 	dscp;
	bit<16> totalLen;
	bit<16> identification;
	bit<3>  flags;
	bit<13> fragOffset;
	bit<8>  ttl;
	bit<8>  protocol;
	bit<16> hdrChecksum;
	bit<32> srcAddr;
	bit<32> dstAddr;
}

header tcp_t {
    bit<16> srcPort;
    bit<16> dstPort;
    bit<32> seqNo;
    bit<32> ackNo;
    bit<4>  dataOffset;
    bit<3>  res;
    bit<3>  ecn;
    bit<6>  ctrl;
    bit<16> window;
    bit<16> checksum;
    bit<16> urgentPtr;
}

header fat_int_case_t{
	bit<8> case;
}

header fat_int_space_t{
	bit<8> queue_space;
	bit<8> hop_space;
	bit<8> egress_space;
}

header fat_int_q_occupancy_t {
	bit<8> q_id;
	bit<24> q_occupancy;
	bit<8> switch_id;
}

header fat_int_hop_latency_t {
	bit<32> hop_latency;
	bit<8> switch_id;
}

header fat_int_egress_timestamp_t {
	bit<32> egress_timestamp;
	bit<8> switch_id;
}

header local_report_header_t {
    bit<16> ingress_port_id;
    bit<8>  queue_id;
    bit<32> ingress_global_tstamp;
}

struct headers {	
	ethernet_t  				ethernet;
	ipv4_t					    ipv4;
	tcp_t 					    tcp;

	local_report_header_t       local_report_header;

	fat_int_case_t 				fat_int_case;
	fat_int_space_t 			fat_int_space;
	fat_int_q_occupancy_t 		fat_int_q1;
	fat_int_q_occupancy_t 		fat_int_q2;
	fat_int_q_occupancy_t 		fat_int_q3;
	fat_int_q_occupancy_t 		fat_int_q4;
	fat_int_q_occupancy_t 		fat_int_q5;
	fat_int_hop_latency_t 		fat_int_hop_latency1;
	fat_int_hop_latency_t 		fat_int_hop_latency2;
	fat_int_hop_latency_t 		fat_int_hop_latency3;
	fat_int_egress_timestamp_t  fat_int_egress_timestamp1;
}

header metadata_t {
	bit<8> switch_id_q_1;
	bit<8> switch_id_q_2;
	bit<8> switch_id_q_3;
	bit<8> switch_id_q_4;
	bit<8> switch_id_q_5;

	bit<8> switch_id_h_1;
	bit<8> switch_id_h_2;
	bit<8> switch_id_h_3;

	bit<8> switch_id_e_1;

	bit<16> global_hash1;

	bit<8> sampling_space_q;
	bit<8> sampling_space_hop;
	bit<8> sampling_space_egress_tst;

	bit<8> remainder_q;
	bit<8> remainder_hop;
	bit<8> remainder_egress;

	bit<1> source;
	bit<1> count_q;
	bit<1> count_hop;
	bit<1> count_egress;

	bit<4> padding;
}

struct ingress_metadata_t {
	metadata_t meta;
}

struct egress_metadata_t {
	metadata_t meta;
}