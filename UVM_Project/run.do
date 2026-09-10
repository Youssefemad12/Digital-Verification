vlog -f files.txt +cover -covercells

vsim -coverage -assertdebug -voptargs=+acc work.top -cover
do exclude.do
coverage save axi4_coverage.ucdb
do wave.do
run -all
coverage report -details -output cov_report.txt
