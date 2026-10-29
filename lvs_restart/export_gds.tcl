puts "\n===== READ DETAILED-ROUTE DATABASE ====="
read_db /work/physical/results/detailed_route.odb

puts "\n===== EXPORT INTERMEDIATE GDS ====="
write_gds /work/physical/lvs_restart/openroad_export.gds

puts "\n===== GDS EXPORT COMMAND COMPLETED ====="
exit
