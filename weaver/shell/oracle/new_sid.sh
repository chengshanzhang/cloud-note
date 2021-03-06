if [ ! -f '/home/after_tag' ];then
  cd /usr/local/oraInventory/
  ./orainstRoot.sh
  cd /usr/local/oracle/product/11.2.0/db_1/
  ./root.sh
  touch /home/after_tag
fi

cd /home
bashrc_text='export ORACLE_BASE=/usr/local/oracle
export ORACLE_HOME=$ORACLE_BASE/product/11.2.0/db_1
export LANG="zh_CN.UTF-8"
export NLS_LANG="SIMPLIFIED CHINESE_CHINA.AL32UTF8"
export NLS_DATE_FORMAT="yyyy-mm-dd hh24:mi:ss"
export PATH=$PATH:$ORACLE_HOME/bin'

echo_bashrc_text="echo '$bashrc_text' >> ~/.bashrc"

echo "$echo_bashrc_text
# 立即生效
source ~/.bashrc

# 静默方式开启监听
# 启动监听
netca /silent /responseFile /usr/local/oracle/netca.rsp | lsnrctl start
cp /home/dbca.rsp /home/oracle/dbca.rsp | dbca -silent -responseFile /home/oracle/dbca.rsp

echo 'export ORACLE_SID=orcl
export ORACLE_OWNER=orcl'>>~/.bashrc
# 立即生效
source ~/.bashrc

echo '# listener.ora Network Configuration File: /usr/local/oracle/product/11.2.0/db_1/network/admin/listener.ora
# Generated by Oracle configuration tools.

# 添加SID相关配置，注意 SID_NAME区分大小写！
SID_LIST_LISTENER =
  (SID_LIST =
    (SID_DESC =
      (ORACLE_HOME =/usr/local/oracle/product/11.2.0/db_1)
      (SID_NAME = orcl)
    )
  )

LISTENER =
  (DESCRIPTION_LIST =
    (DESCRIPTION =
      (ADDRESS = (PROTOCOL = IPC)(KEY = EXTPROC1521))
      (ADDRESS = (PROTOCOL = TCP)(HOST = localhost)(PORT = 1521))
    )
  )

ADR_BASE_LISTENER = /usr/local/oracle' > /usr/local/oracle/product/11.2.0/db_1/network/admin/listener.ora

lsnrctl stop
lsnrctl start
">config_oracle.sh

chmod +x ./config_oracle.sh
su - oracle -s /bin/sh /home/config_oracle.sh