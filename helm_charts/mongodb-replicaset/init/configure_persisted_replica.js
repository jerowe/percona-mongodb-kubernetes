//This script assumes that there are 3 replicas
// and that the 3rd persists to disk

cfg = rs.conf()
cfg.members[0].priority = 0
cfg.members[0].hidden = true
rs.reconfig(cfg, {force: true})
