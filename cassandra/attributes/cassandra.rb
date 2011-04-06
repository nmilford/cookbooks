# Copyright 2011, Outbrain, Inc.
#
# Licensed under the Apache License, Version 2.0 (the "License");
# you may not use this file except in compliance with the License.
# You may obtain a copy of the License at
#
#     http://www.apache.org/licenses/LICENSE-2.0
#
# Unless required by applicable law or agreed to in writing, software
# distributed under the License is distributed on an "AS IS" BASIS,
# WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
# See the License for the specific language governing permissions and
# limitations under the License.

default[:Cassandra][:Version] = "0.7.4-1"

# /etc/cassandra/conf/cassandra.yaml
default[:Cassandra][:cluster_name] = "Test Cluster"
default[:Cassandra][:initial_toke] = ""
default[:Cassandra][:auto_bootstrap] = false
default[:Cassandra][:hinted_handoff_enabled] = true
default[:Cassandra][:max_hint_window_in_ms] = 3600000
default[:Cassandra][:hinted_handoff_throttle_delay_in_ms] = 50
default[:Cassandra][:authenticator] = "org.apache.cassandra.auth.AllowAllAuthenticator"
default[:Cassandra][:authority] = "org.apache.cassandra.auth.AllowAllAuthority"
default[:Cassandra][:partitioner] = "org.apache.cassandra.dht.RandomPartitioner"
default[:Cassandra][:data_file_directories] = "/var/lib/cassandra/data"
default[:Cassandra][:commitlog_directory] = "/var/lib/cassandra/commitlog"
default[:Cassandra][:saved_caches_directory] = "/var/lib/cassandra/saved_caches"
default[:Cassandra][:commitlog_rotation_threshold_in_mb] = 128
default[:Cassandra][:commitlog_sync] = "periodic"
default[:Cassandra][:commitlog_sync_period_in_ms] = 10000
default[:Cassandra][:flush_largest_memtables_at] = 0.75
default[:Cassandra][:reduce_cache_sizes_at] = 0.85
default[:Cassandra][:reduce_cache_capacity_to] = 0.6
default[:Cassandra][:seeds] = ["192.168.1.1"]
default[:Cassandra][:disk_access_mode] = "auto"
default[:Cassandra][:concurrent_reads] = 32
default[:Cassandra][:concurrent_writes] = 32
default[:Cassandra][:memtable_flush_writers] = 1
default[:Cassandra][:sliced_buffer_size_in_kb] = 64
default[:Cassandra][:storage_port] = 7000
default[:Cassandra][:rpc_port] = 9160
default[:Cassandra][:rpc_keepalive] = true
default[:Cassandra][:thrift_framed_transport_size_in_mb] = 15
default[:Cassandra][:thrift_max_message_length_in_mb] = 16
default[:Cassandra][:incremental_backups] = false
default[:Cassandra][:snapshot_before_compaction] = false
default[:Cassandra][:column_index_size_in_kb] = 64
default[:Cassandra][:in_memory_compaction_limit_in_mb] = 64
default[:Cassandra][:compaction_preheat_key_cache] = true
default[:Cassandra][:rpc_timeout_in_ms] = 10000
default[:Cassandra][:phi_convict_threshold] = 8
default[:Cassandra][:endpoint_snitch] = "org.apache.cassandra.locator.SimpleSnitch"
default[:Cassandra][:dynamic_snitch] = true
default[:Cassandra][:dynamic_snitch_update_interval_in_ms] = 100 
default[:Cassandra][:dynamic_snitch_reset_interval_in_ms] = 600000
default[:Cassandra][:dynamic_snitch_badness_threshold] = 0.0
default[:Cassandra][:request_scheduler] = "org.apache.cassandra.scheduler.NoScheduler"
default[:Cassandra][:index_interval] = 128
