
parser SwitchIngressParser(packet_in packet,
                           out headers hdr,
                           out ingress_metadata_t ig_md,
                           out ingress_intrinsic_metadata_t ig_intr_md) {
    state start {
        packet.extract(ig_intr_md);
        packet.advance(PORT_METADATA_SIZE);

        transition parse_ethernet;
    }

    state parse_ethernet {
        packet.extract(hdr.ethernet);
        packet.extract(hdr.ipv4);
        packet.extract(hdr.tcp);
        ig_md.meta.setValid();
        transition select (hdr.ipv4.dscp){
            INT: fat_int;
            default: accept;
        }
    }

    state fat_int {
        packet.extract(hdr.fat_int_case);
        packet.extract(hdr.fat_int_space);
        transition select (hdr.fat_int_space.queue_space){
            1 :fat_int_q1;
            2 :fat_int_q2;
            3 :fat_int_q3;
            4 :fat_int_q4;
            5 :fat_int_q5;
            default : accept;
        }
    }

    state fat_int_q1{
        packet.extract(hdr.fat_int_q1);
        transition select (hdr.fat_int_space.hop_space){
            1 :fat_int_hop_latency1;
            2 :fat_int_hop_latency2;
            3 :fat_int_hop_latency3;
            default : accept;
        }
    }

    state fat_int_q2{
        packet.extract(hdr.fat_int_q1);
        packet.extract(hdr.fat_int_q2);
        transition select (hdr.fat_int_space.hop_space){
            1 :fat_int_hop_latency1;
            2 :fat_int_hop_latency2;
            3 :fat_int_hop_latency3;
            default : accept;
        }
    }

    state fat_int_q3{
        packet.extract(hdr.fat_int_q1);
        packet.extract(hdr.fat_int_q2);
        packet.extract(hdr.fat_int_q3);
        transition select (hdr.fat_int_space.hop_space){
            1 :fat_int_hop_latency1;
            2 :fat_int_hop_latency2;
            3 :fat_int_hop_latency3;
            default : accept;
        }
    }

    state fat_int_q4{
        packet.extract(hdr.fat_int_q1);
        packet.extract(hdr.fat_int_q2);
        packet.extract(hdr.fat_int_q3);
        packet.extract(hdr.fat_int_q4);
        transition select (hdr.fat_int_space.hop_space){
            1 :fat_int_hop_latency1;
            2 :fat_int_hop_latency2;
            3 :fat_int_hop_latency3;
            default : accept;
        }
    }

    state fat_int_q5{
        packet.extract(hdr.fat_int_q1);
        packet.extract(hdr.fat_int_q2);
        packet.extract(hdr.fat_int_q3);
        packet.extract(hdr.fat_int_q4);
        packet.extract(hdr.fat_int_q5);
        transition select (hdr.fat_int_space.hop_space){
            1 :fat_int_hop_latency1;
            2 :fat_int_hop_latency2;
            3 :fat_int_hop_latency3;
            default : accept;
        }
    }

    state fat_int_hop_latency1{
        packet.extract(hdr.fat_int_hop_latency1);
        transition select (hdr.fat_int_space.egress_space){
            1 :fat_int_egress_timestamp1;
            default : accept;
        }
    }

    state fat_int_hop_latency2{
        packet.extract(hdr.fat_int_hop_latency1);
        packet.extract(hdr.fat_int_hop_latency2);
        transition select (hdr.fat_int_space.egress_space){
            1 :fat_int_egress_timestamp1;
            default : accept;
        }
    }

    state fat_int_hop_latency3{
        packet.extract(hdr.fat_int_hop_latency1);
        packet.extract(hdr.fat_int_hop_latency2);
        packet.extract(hdr.fat_int_hop_latency3);
        transition select (hdr.fat_int_space.egress_space){
            1 :fat_int_egress_timestamp1;
            default : accept;
        }
    }

    state fat_int_egress_timestamp1{
        packet.extract(hdr.fat_int_egress_timestamp1);
        transition accept;
    }
}

control SwitchIngressDeparser(packet_out packet, 
                              inout headers hdr,
                              in ingress_metadata_t ig_md,
                              in ingress_intrinsic_metadata_for_deparser_t ig_dprsr_md) {
    apply {
        packet.emit(ig_md.meta);
        packet.emit(hdr);
    }
}

parser SwitchEgressParser(packet_in packet,
                          out headers hdr,
                          out egress_metadata_t eg_md, 
                          out egress_intrinsic_metadata_t eg_intr_md) {	
    state start {
        packet.extract(eg_intr_md);
        packet.extract(eg_md.meta);
        transition parse_ethernet;
    }

    state parse_ethernet {
        packet.extract(hdr.ethernet);
        packet.extract(hdr.ipv4);
        packet.extract(hdr.tcp);
        transition select (hdr.ipv4.dscp){
            INT: fat_int;
            default: accept;
        }
    }

    state fat_int {
        packet.extract(hdr.local_report_header);
        packet.extract(hdr.fat_int_case);
        packet.extract(hdr.fat_int_space);
        transition select (hdr.fat_int_space.queue_space){
            1 :fat_int_q1;
            2 :fat_int_q2;
            3 :fat_int_q3;
            4 :fat_int_q4;
            5 :fat_int_q5;
            default : accept;
        }
    }

    state fat_int_q1{
        packet.extract(hdr.fat_int_q1);
        transition select (hdr.fat_int_space.hop_space){
            1 :fat_int_hop_latency1;
            2 :fat_int_hop_latency2;
            3 :fat_int_hop_latency3;
            default : accept;
        }
    }

    state fat_int_q2{
        packet.extract(hdr.fat_int_q1);
        packet.extract(hdr.fat_int_q2);
        transition select (hdr.fat_int_space.hop_space){
            1 :fat_int_hop_latency1;
            2 :fat_int_hop_latency2;
            3 :fat_int_hop_latency3;
            default : accept;
        }
    }

    state fat_int_q3{
        packet.extract(hdr.fat_int_q1);
        packet.extract(hdr.fat_int_q2);
        packet.extract(hdr.fat_int_q3);
        transition select (hdr.fat_int_space.hop_space){
            1 :fat_int_hop_latency1;
            2 :fat_int_hop_latency2;
            3 :fat_int_hop_latency3;
            default : accept;
        }
    }

    state fat_int_q4{
        packet.extract(hdr.fat_int_q1);
        packet.extract(hdr.fat_int_q2);
        packet.extract(hdr.fat_int_q3);
        packet.extract(hdr.fat_int_q4);
        transition select (hdr.fat_int_space.hop_space){
            1 :fat_int_hop_latency1;
            2 :fat_int_hop_latency2;
            3 :fat_int_hop_latency3;
            default : accept;
        }
    }

    state fat_int_q5{
        packet.extract(hdr.fat_int_q1);
        packet.extract(hdr.fat_int_q2);
        packet.extract(hdr.fat_int_q3);
        packet.extract(hdr.fat_int_q4);
        packet.extract(hdr.fat_int_q5);
        transition select (hdr.fat_int_space.hop_space){
            1 :fat_int_hop_latency1;
            2 :fat_int_hop_latency2;
            3 :fat_int_hop_latency3;
            default : accept;
        }
    }

    state fat_int_hop_latency1{
        packet.extract(hdr.fat_int_hop_latency1);
        transition select (hdr.fat_int_space.egress_space){
            1 :fat_int_egress_timestamp1;
            default : accept;
        }
    }

    state fat_int_hop_latency2{
        packet.extract(hdr.fat_int_hop_latency1);
        packet.extract(hdr.fat_int_hop_latency2);
        transition select (hdr.fat_int_space.egress_space){
            1 :fat_int_egress_timestamp1;
            default : accept;
        }
    }

    state fat_int_hop_latency3{
        packet.extract(hdr.fat_int_hop_latency1);
        packet.extract(hdr.fat_int_hop_latency2);
        packet.extract(hdr.fat_int_hop_latency3);
        transition select (hdr.fat_int_space.egress_space){
            1 :fat_int_egress_timestamp1;
            default : accept;
        }
    }

    state fat_int_egress_timestamp1{
        packet.extract(hdr.fat_int_egress_timestamp1);
        transition accept;
    }
}


control SwitchEgressDeparser(packet_out packet, 
                             inout headers hdr,
                             in egress_metadata_t eg_md, 
                             in egress_intrinsic_metadata_for_deparser_t eg_dprsr_md) {
    apply {
        packet.emit(hdr.ethernet);
        packet.emit(hdr.ipv4);
        packet.emit(hdr.tcp);
        packet.emit(hdr.fat_int_case);
        packet.emit(hdr.fat_int_space);
        packet.emit(hdr.fat_int_q1);
        packet.emit(hdr.fat_int_q2);
        packet.emit(hdr.fat_int_q3);
        packet.emit(hdr.fat_int_q4);
        packet.emit(hdr.fat_int_q5);
        packet.emit(hdr.fat_int_hop_latency1);
        packet.emit(hdr.fat_int_hop_latency2);
        packet.emit(hdr.fat_int_hop_latency3);
        packet.emit(hdr.fat_int_egress_timestamp1);
    }
}