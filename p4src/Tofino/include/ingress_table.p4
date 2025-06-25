table tb_set_source {
	key = {
		hdr.ipv4.dscp : exact;
	}
	actions = {
		int_set_source;
		NoAction();
	}
	default_action = NoAction();
	size = 1;
}

table tb_valid_space { 
	key = {
		ig_md.meta.source: exact;
		ig_md.meta.global_hash1 : range;
	}
	actions = {
		valid_space();
		NoAction();
	}
	default_action = NoAction();
	size = 2;
}

table tb_set_switch_id {
	key = {
		hdr.ipv4.version: exact;
	}
	actions = {
		set_switch_id;
	}
	size = 1;
}

table tb_set_local_hdr {
	actions = {
		set_local_hdr;
	}
	const default_action = set_local_hdr();
	size =1;
}

table tb_set_space {
	key = {
		hdr.fat_int_case.case: exact;
	}
	actions = {
		set_space();
		NoAction();
	}
	default_action = NoAction();
	size = 16;
}

table tb_valid_space_q {
	key = {
		hdr.fat_int_space.queue_space: exact;
	}
	actions = {
		valid_space_q1();
		valid_space_q2();
		valid_space_q3();
		valid_space_q4();
		valid_space_q5();
		NoAction();
	}
	default_action = NoAction();
	size = 5;
}

table tb_valid_space_hop {
	key = {
		hdr.fat_int_space.hop_space: exact;
	}
	actions = {
		valid_space_hop1();
		valid_space_hop2();
		valid_space_hop3();
		NoAction();
	}
	default_action = NoAction();
	size = 3;
}

table tb_valid_space_egress {
	key = {
		hdr.fat_int_space.egress_space: exact;
	}
	actions = {		
		valid_space_egress1();
		NoAction();
	}
	default_action = NoAction();
	size = 1;
}

table tb_forward {
	key = {
		ig_intr_md.ingress_port: exact;
	}
	actions = {
		set_egress_port;
		NoAction();
	}
	default_action = NoAction();
}