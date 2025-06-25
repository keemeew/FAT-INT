import math

p4_ingress = bfrt.fat_int.pipe.SwitchIngress

ttl = 61
switch_count = (65-ttl)

sampling_space_q = 5
sampling_space_hop = 3
sampling_space_egress = 1

remainder_q_rule = switch_count%sampling_space_q
remainder_hop_rule = switch_count%sampling_space_hop
remainder_egress_rule = switch_count%sampling_space_egress

approximation_q =  ((1/math.ceil(switch_count/sampling_space_q))*65535)
approximation_hop =  ((1/math.ceil(switch_count/sampling_space_hop))*65535)
approximation_egress =  ((1/math.ceil(switch_count/sampling_space_egress))*65535)

tb_set_source = p4_ingress.tb_set_source
tb_set_source.add_with_int_set_source(
    # hdr.ipv4.dscp : exact;
    dscp=0x3
)
print("tb_set_source completed")

tb_set_switch_id = p4_ingress.tb_set_switch_id
tb_set_switch_id.add_with_set_switch_id(
    # 65x2 : 1, 65x : 2, 32x : 3
    # hdr.ipv4.version: exact;
    version = 4,
    switch_id = 1
)
print("tb_set_switch_id completed")

# Update for prob. in FAT-INT
tb_valid_space = p4_ingress.tb_valid_space
tb_valid_space.add_with_valid_space(
    # ig_md.meta.source: exact;
    # ig_md.meta.global_hash1 : range;
    source=0x1,
    global_hash1_start=0, global_hash1_end=32768,

    case=0
)
print("tb_valid_space completed")

# update for server port, nubmer of space
tb_set_space = p4_ingress.tb_set_space
tb_set_space.add_with_set_space(
    # hdr.fat_int_space.case: exact;
    case = 0, # host9
    
    # bit<8> queue_space, bit<8> hop_space, bit<8> egress_space
    queue_space = sampling_space_q,
    hop_space = sampling_space_hop,
    egress_space = sampling_space_egress
)
print("tb_set_space completed")

tb_forward = p4_ingress.tb_forward
tb_forward.add_with_set_egress_port(
    # ig_intr_md.ingress_port: exact;
    ingress_port = 0,

    egress_spec = 1
)
print("tb_forward completed")

tb_valid_space_q = p4_ingress.tb_valid_space_q
tb_valid_space_q.add_with_valid_space_q1(
    # hdr.fat_int_space.queue_space: exact;

    queue_space = 0
)
print("tb_valid_space_q1 completed")

tb_valid_space_q = p4_ingress.tb_valid_space_q
tb_valid_space_q.add_with_valid_space_q2(
    # hdr.fat_int_space.queue_space: exact;

    queue_space = 1
)
print("tb_valid_space_q2 completed")

tb_valid_space_q = p4_ingress.tb_valid_space_q
tb_valid_space_q.add_with_valid_space_q3(
    # hdr.fat_int_space.queue_space: exact;

    queue_space = 2
)
print("tb_valid_space_q3 completed")

tb_valid_space_q = p4_ingress.tb_valid_space_q
tb_valid_space_q.add_with_valid_space_q4(
    # hdr.fat_int_space.queue_space: exact;

    queue_space = 3
)
print("tb_valid_space_q4 completed")

tb_valid_space_q = p4_ingress.tb_valid_space_q
tb_valid_space_q.add_with_valid_space_q5(
    # hdr.fat_int_space.queue_space: exact;

    queue_space = 4
)
print("tb_valid_space_q5 completed")

tb_valid_space_hop = p4_ingress.tb_valid_space_hop
tb_valid_space_hop.add_with_valid_space_hop1(
    # hdr.fat_int_space.hop_space: exact;

    hop_space = 0
)
print("tb_valid_space_hop1 completed")

tb_valid_space_hop = p4_ingress.tb_valid_space_hop
tb_valid_space_hop.add_with_valid_space_hop2(
    # hdr.fat_int_space.hop_space: exact;

    hop_space = 1
)
print("tb_valid_space_hop2 completed")

tb_valid_space_hop = p4_ingress.tb_valid_space_hop
tb_valid_space_hop.add_with_valid_space_hop3(
    # hdr.fat_int_space.hop_space: exact;

    hop_space = 2
)
print("tb_valid_space_hop3 completed")

tb_valid_space_egress = p4_ingress.tb_valid_space_egress
tb_valid_space_egress.add_with_valid_space_egress1(
    # hdr.fat_int_space.egress_space: exact;

    egress_space = 0
)
print("tb_valid_space_egress1 completed")

#############################################################


p4_egress = bfrt.fat_int.pipe.SwitchEgress

#Update for space number and count
tb_set_param = p4_egress.tb_set_param
tb_set_param.add_with_set_param(
    # hdr.ipv4.ttl : exact;
    # eg_md.meta.sampling_space_q : exact;
    # eg_md.meta.sampling_space_hop : exact;
    # eg_md.meta.sampling_space_egress_tst : exact;
    ttl = 63,
    sampling_space_q = sampling_space_q,
    sampling_space_hop = sampling_space_hop,
    sampling_space_egress_tst = sampling_space_egress,

    remainder_q = remainder_q_rule,
    remainder_hop = remainder_hop_rule,
    remainder_egress = remainder_egress_rule
)
print("tb_set_param completed")

tb_insert_q = p4_egress.tb_insert_q
tb_insert_q.add_with_set_q1(
    # eg_md.meta.count_q: exact;
    # hdr.fat_int_space.queue_space: exact;
    # eg_md.meta.sampling_space_q: exact;
    # eg_md.meta.remainder_q : exact;	
    # eg_md.meta.global_hash1 : range;

    count_q = 1,
    queue_space = 1,
    sampling_space_q = sampling_space_q,
    remainder_q = remainder_q_rule,
    global_hash1_start=0,global_hash1_end=65535
)
print("set_q 1 completed")

tb_insert_q = p4_egress.tb_insert_q
tb_insert_q.add_with_set_q2(
    # eg_md.meta.count_q: exact;
    # hdr.fat_int_space.queue_space: exact;
    # eg_md.meta.sampling_space_q: exact;
    # eg_md.meta.remainder_q : exact;	
    # eg_md.meta.global_hash1 : range;

    count_q = 1,
    queue_space = 2,
    sampling_space_q = sampling_space_q,
    remainder_q = remainder_q_rule,
    global_hash1_start=0,global_hash1_end=65535
)
print("set_q 2 completed")

tb_insert_q = p4_egress.tb_insert_q
tb_insert_q.add_with_set_q3(
    # eg_md.meta.count_q: exact;
    # hdr.fat_int_space.queue_space: exact;
    # eg_md.meta.sampling_space_q: exact;
    # eg_md.meta.remainder_q : exact;	
    # eg_md.meta.global_hash1 : range;

    count_q = 1,
    queue_space = 3,
    sampling_space_q = sampling_space_q,
    remainder_q = remainder_q_rule,
    global_hash1_start=0,global_hash1_end=65535
)
print("set_q 3 completed")

tb_insert_q = p4_egress.tb_insert_q
tb_insert_q.add_with_set_q4(
    # eg_md.meta.count_q: exact;
    # hdr.fat_int_space.queue_space: exact;
    # eg_md.meta.sampling_space_q: exact;
    # eg_md.meta.remainder_q : exact;	
    # eg_md.meta.global_hash1 : range;

    count_q = 1,
    queue_space = 4,
    sampling_space_q = sampling_space_q,
    remainder_q = remainder_q_rule,
    global_hash1_start=0,global_hash1_end=65535
)
print("set_q 4 completed")

tb_insert_q = p4_egress.tb_insert_q
tb_insert_q.add_with_set_q5(
    # eg_md.meta.count_q: exact;
    # hdr.fat_int_space.queue_space: exact;
    # eg_md.meta.sampling_space_q: exact;
    # eg_md.meta.remainder_q : exact;	
    # eg_md.meta.global_hash1 : range;

    count_q = 1,
    queue_space = 5,
    sampling_space_q = sampling_space_q,
    remainder_q = remainder_q_rule,
    global_hash1_start=0,global_hash1_end=65535
)
print("set_q 5 completed")

tb_insert_q = p4_egress.tb_insert_q
tb_insert_q.add_with_index_q1(
    # eg_md.meta.count_q: exact;
    # hdr.fat_int_space.queue_space: exact;
    # eg_md.meta.sampling_space_q: exact;
    # eg_md.meta.remainder_q : exact;	
    # eg_md.meta.global_hash1 : range;

    count_q = 0,
    queue_space = 5,
    sampling_space_q = sampling_space_q,
    remainder_q = 1,
    global_hash1_start=0,global_hash1_end=approximation_q
)
print("index_q 1 completed")

tb_insert_q = p4_egress.tb_insert_q
tb_insert_q.add_with_index_q2(
    # eg_md.meta.count_q: exact;
    # hdr.fat_int_space.queue_space: exact;
    # eg_md.meta.sampling_space_q: exact;
    # eg_md.meta.remainder_q : exact;	
    # eg_md.meta.global_hash1 : range;

    count_q = 0,
    queue_space = 5,
    sampling_space_q = sampling_space_q,
    remainder_q = 2,
    global_hash1_start=0,global_hash1_end=approximation_q
)
print("index_q 2 completed")

tb_insert_q = p4_egress.tb_insert_q
tb_insert_q.add_with_index_q3(
    # eg_md.meta.count_q: exact;
    # hdr.fat_int_space.queue_space: exact;
    # eg_md.meta.sampling_space_q: exact;
    # eg_md.meta.remainder_q : exact;	
    # eg_md.meta.global_hash1 : range;

    count_q = 0,
    queue_space = 5,
    sampling_space_q = sampling_space_q,
    remainder_q = 3,
    global_hash1_start=0,global_hash1_end=approximation_q
)
print("index_q 3 completed")

tb_insert_q = p4_egress.tb_insert_q
tb_insert_q.add_with_index_q4(
    # eg_md.meta.count_q: exact;
    # hdr.fat_int_space.queue_space: exact;
    # eg_md.meta.sampling_space_q: exact;
    # eg_md.meta.remainder_q : exact;	
    # eg_md.meta.global_hash1 : range;

    count_q = 0,
    queue_space = 5,
    sampling_space_q = sampling_space_q,
    remainder_q = 4,
    global_hash1_start=0,global_hash1_end=approximation_q
)
print("index_q 4 completed")

tb_insert_q = p4_egress.tb_insert_q
tb_insert_q.add_with_index_q5(
    # eg_md.meta.count_q: exact;
    # hdr.fat_int_space.queue_space: exact;
    # eg_md.meta.sampling_space_q: exact;
    # eg_md.meta.remainder_q : exact;	
    # eg_md.meta.global_hash1 : range;

    count_q = 0,
    queue_space = 5,
    sampling_space_q = sampling_space_q,
    remainder_q = 0,
    global_hash1_start=0,global_hash1_end=approximation_q
)
print("index_q 5 completed")

tb_insert_hop = p4_egress.tb_insert_hop
tb_insert_hop.add_with_set_hop1(
    # eg_md.meta.count_hop: exact;
    # hdr.fat_int_space.hop_space: exact;
    # eg_md.meta.sampling_space_hop: exact;
    # eg_md.meta.remainder_hop : exact;
    # eg_md.meta.global_hash1 : range;	

    count_hop = 1,
    hop_space = 1,
    sampling_space_hop = sampling_space_hop,
    remainder_hop = remainder_q_rule,
    global_hash1_start=0,global_hash1_end=65535
)
print("set_hop 1 completed")

tb_insert_hop = p4_egress.tb_insert_hop
tb_insert_hop.add_with_set_hop2(
    # eg_md.meta.count_hop: exact;
    # hdr.fat_int_space.hop_space: exact;
    # eg_md.meta.sampling_space_hop: exact;
    # eg_md.meta.remainder_hop : exact;
    # eg_md.meta.global_hash1 : range;	

    count_hop = 1,
    hop_space = 2,
    sampling_space_hop = sampling_space_hop,
    remainder_hop = remainder_q_rule,
    global_hash1_start=0,global_hash1_end=65535
)
print("set_hop 2 completed")

tb_insert_hop = p4_egress.tb_insert_hop
tb_insert_hop.add_with_set_hop3(
    # eg_md.meta.count_hop: exact;
    # hdr.fat_int_space.hop_space: exact;
    # eg_md.meta.sampling_space_hop: exact;
    # eg_md.meta.remainder_hop : exact;
    # eg_md.meta.global_hash1 : range;	

    count_hop = 1,
    hop_space = 3,
    sampling_space_hop = sampling_space_hop,
    remainder_hop = remainder_q_rule,
    global_hash1_start=0,global_hash1_end=65535
)
print("set_hop 3 completed")

tb_insert_hop = p4_egress.tb_insert_hop
tb_insert_hop.add_with_index_hop1(
    # eg_md.meta.count_hop: exact;
    # hdr.fat_int_space.hop_space: exact;
    # eg_md.meta.sampling_space_hop: exact;
    # eg_md.meta.remainder_hop : exact;
    # eg_md.meta.global_hash1 : range;	

    count_hop = 0,
    hop_space = sampling_space_hop,
    sampling_space_hop = sampling_space_hop,
    remainder_hop = 1,
    global_hash1_start=0,global_hash1_end=approximation_hop
)
print("index_hop 1 completed")

tb_insert_hop = p4_egress.tb_insert_hop
tb_insert_hop.add_with_index_hop2(
    # eg_md.meta.count_hop: exact;
    # hdr.fat_int_space.hop_space: exact;
    # eg_md.meta.sampling_space_hop: exact;
    # eg_md.meta.remainder_hop : exact;
    # eg_md.meta.global_hash1 : range;	

    count_hop = 0,
    hop_space = sampling_space_hop,
    sampling_space_hop = sampling_space_hop,
    remainder_hop = 2,
    global_hash1_start=0,global_hash1_end=approximation_hop
)
print("index_hop 2 completed")

tb_insert_hop = p4_egress.tb_insert_hop
tb_insert_hop.add_with_index_hop3(
    # eg_md.meta.count_hop: exact;
    # hdr.fat_int_space.hop_space: exact;
    # eg_md.meta.sampling_space_hop: exact;
    # eg_md.meta.remainder_hop : exact;
    # eg_md.meta.global_hash1 : range;	

    count_hop = 0,
    hop_space = sampling_space_hop,
    sampling_space_hop = sampling_space_hop,
    remainder_hop = 0,
    global_hash1_start=0,global_hash1_end=approximation_hop
)
print("index_hop 3 completed")

tb_insert_egress = p4_egress.tb_insert_egress
tb_insert_egress.add_with_set_egress1(
    # eg_md.meta.count_egress: exact;
    # hdr.fat_int_space.egress_space: exact;
    # eg_md.meta.sampling_space_egress_tst: exact;
    # eg_md.meta.remainder_egress : exact;	
    # eg_md.meta.global_hash1 : range;

    count_egress = 1,
    egress_space = 1,
    sampling_space_egress_tst = sampling_space_egress,
    remainder_egress = remainder_egress_rule,
    global_hash1_start=0,global_hash1_end=65535
)
print("set_egress 1 completed")

tb_insert_egress = p4_egress.tb_insert_egress
tb_insert_egress.add_with_index_egress1(
    # eg_md.meta.count_egress: exact;
    # hdr.fat_int_space.egress_space: exact;
    # eg_md.meta.sampling_space_egress_tst: exact;
    # eg_md.meta.remainder_egress : exact;	
    # eg_md.meta.global_hash1 : range;

    count_egress = 0,
    egress_space = 1,
    sampling_space_egress_tst = sampling_space_egress,
    remainder_egress = 0,
    global_hash1_start=0,global_hash1_end=approximation_egress
)
print("index_egress 1 completed")
