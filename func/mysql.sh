function mysql-connect-slave ()
{
    mysql --default-character-set=utf8 $_mysql_opts -h ${DB_CONNECT[$table:'slave_mysql_host']:-$slave_mysql_host} -P ${DB_CONNECT[$table:'slave_mysql_port']:-$slave_mysql_port} -u ${DB_CONNECT[$table:'slave_mysql_user']:-$slave_mysql_user} --database=${DB_CONNECT[$table:'slave_mysql_dbname']:-$slave_mysql_dbname} -p${DB_CONNECT[$table:'slave_mysql_password']:-$slave_mysql_password} -e "$*\G" 2>/dev/null 
    echo END
}

function mysql-connector-master ()
{
    mysql --default-character-set=utf8 -h ${DB_CONNECT[$table:'master_mysql_host']:-$master_mysql_host} -P ${DB_CONNECT[$table:'master_mysql_port']:-$master_mysql_port} -u ${DB_CONNECT[$table:'master_mysql_user']:-$master_mysql_user} --database=${DB_CONNECT[$table:'master_mysql_dbname']:-$master_mysql_dbname} -p${DB_CONNECT[$table:'master_mysql_password']:-$master_mysql_password} -e "$*\G" 2>/dev/null
    echo END
}

function mysql-to-json ()
{
    local display="$1" result
    typeset -A arr
    while read -r line
    do
        if [[ "${line}" =~ .*row.* || "$line" == "END" ]]
        then
            if [[ "$display" == "$matcher" ]]
            then
                [[ ! -z "${arr[@]}" ]] && results+="$(array-to-json arr),"
            else
                [[ ! -z "${arr[@]}" ]] && results+="\"${arr[$display]}\":$(array-to-json arr),"
            fi
        elif ! [[ "${line}" =~ .*row.* || "$line" == "END" ]]
       then
            result="${line#*:}"
            trim result
            arr[${line%%:*}]="$result"
        fi 
    done < <($mysql_command "${*:2}" | grep -v -e '^$' | tr -d '\r')

    
    if [[ "$display" == "$matcher" ]]
    then
        echo "{ \"$matcher\": [ ${results%,} ] }"
    else
        echo "{ \"$matcher\": { ${results%,} } }"
    fi
}

