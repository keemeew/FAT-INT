#include <core.p4>
#include <tna.p4>

#define INT 20

#include "include/header.p4"
#include "include/parser.p4"

control SwitchIngress(inout headers hdr, 
                      inout ingress_metadata_t ig_md, 
		      in ingress_intrinsic_metadata_t ig_intr_md, 
		      in ingress_intrinsic_metadata_from_parser_t ig_prsr_md, 
		      inout ingress_intrinsic_metadata_for_deparser_t ig_dprsr_md, 
		      inout ingress_intrinsic_metadata_for_tm_t ig_tm_md) {

	#include "include/ingress_action.p4"
	#include "include/ingress_table.p4"

	Hash<bit<16>>(HashAlgorithm_t.CRC32) global_hash1;

	apply {
		tb_set_source.apply();
		ig_md.meta.global_hash1 = global_hash1.get({hdr.ipv4.srcAddr,
		   					    hdr.ipv4.dstAddr,
							    hdr.ipv4.protocol,
							    hdr.ipv4.identification,
							    hdr.tcp.srcPort,
							    hdr.tcp.dstPort,
							    hdr.ipv4.ttl});
													
		tb_valid_space.apply();
		if (hdr.fat_int_space.isValid()){
			tb_set_switch_id.apply();
			tb_set_local_hdr.apply();
			
			tb_set_space.apply();
			if (ig_md.meta.sampling_space_q != (hdr.fat_int_space.queue_space)){
				tb_valid_space_q.apply();
			}
			if (ig_md.meta.sampling_space_hop != (hdr.fat_int_space.hop_space)){
				tb_valid_space_hop.apply();	
			}
			if (ig_md.meta.sampling_space_egress_tst != (hdr.fat_int_space.egress_space)){
				tb_valid_space_egress.apply();	
			}
		}
		tb_forward.apply();
	}
}

control SwitchEgress(inout headers hdr, 
		     inout egress_metadata_t eg_md, 
 		     in egress_intrinsic_metadata_t eg_intr_md, 
		     in egress_intrinsic_metadata_from_parser_t eg_prsr_md, 
		     inout egress_intrinsic_metadata_for_deparser_t eg_dprsr_md, 
		     inout egress_intrinsic_metadata_for_output_port_t eg_oport_md) {
		
	#include "include/egress_action.p4"
	#include "include/egress_table.p4"

	apply {
		if (hdr.fat_int_space.isValid()){
			tb_set_param.apply();
			
			tb_insert_q.apply();
			tb_insert_hop.apply();
			tb_insert_egress.apply();

			hdr.local_report_header.setInvalid();
		}
	}
}

Pipeline(SwitchIngressParser(),
	SwitchIngress(),
	SwitchIngressDeparser(),
	SwitchEgressParser(),
	SwitchEgress(),
	SwitchEgressDeparser()
) pipe;

Switch(pipe) main;
