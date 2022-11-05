function read_csr() {
	csr=$1
	openssl req -in $csr -noout -text
}