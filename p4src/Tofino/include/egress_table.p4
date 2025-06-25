table tb_set_param {
	key={
		hdr.ipv4.ttl : exact;
		eg_md.meta.sampling_space_q : exact;
		eg_md.meta.sampling_space_hop : exact;
		eg_md.meta.sampling_space_egress_tst : exact;
	}
	actions={
		set_param;
		NoAction();
	}
	size = 20;
	default_action = NoAction();
}

table tb_insert_q{
	key = {
		eg_md.meta.count_q: exact;
		hdr.fat_int_space.queue_space: exact;
		eg_md.meta.sampling_space_q: exact;
		eg_md.meta.remainder_q : exact;	
		eg_md.meta.global_hash1 : range;
	}
	actions = {
		set_q1;
		set_q2;
		set_q3;
		set_q4;
		set_q5;
		index_q1;
		index_q2;
		index_q3;
		index_q4;
		index_q5;
		NoAction();
	}
	default_action = NoAction();
	size = 10;

}

table tb_insert_hop {
	key = {
		eg_md.meta.count_hop: exact;
		hdr.fat_int_space.hop_space: exact;
		eg_md.meta.sampling_space_hop: exact;
		eg_md.meta.remainder_hop : exact;
		eg_md.meta.global_hash1 : range;	
	}
	actions = {
		set_hop1;
		set_hop2;
		set_hop3;
		index_hop1;
		index_hop2;
		index_hop3;
		NoAction();
	}
	default_action = NoAction();
	size = 6;
}

table tb_insert_egress {
	key = {
		eg_md.meta.count_egress: exact;
		hdr.fat_int_space.egress_space: exact;
		eg_md.meta.sampling_space_egress_tst: exact;
		eg_md.meta.remainder_egress : exact;	
		eg_md.meta.global_hash1 : range;
	}
	actions = {
		set_egress1;
		index_egress1;
		NoAction();
	}
	default_action = NoAction();
	size = 2;
}