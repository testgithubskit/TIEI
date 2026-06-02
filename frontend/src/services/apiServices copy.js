import axios from 'axios';

export const backendApi = axios.create({
    // baseURL: 'http://192.168.217.61:7788/api/v1'
    // baseURL: 'http://10.82.126.73:7788/api/v1'      //Clinets IP TNGA
    // baseURL: 'http://172.18.7.27:7788/api/v1'
    // baseURL: 'http://172.18.100.87:8000/api/v1'  //LOCAL NIHAL DM
    baseURL: 'https://172.18.7.91:8888/api/v1'  //UBUSMC
    // baseURL: 'http://172.18.101.47:6699/api/v1' //Pavi
    // baseURL : 'http://172.18.100.240:6699/api/v1'
    // baseURL : 'http://10.82.126.73:8877/api/v1'   //CLINETS IP GD PLANT
    // baseURL: 'http://172.18.100.150:7788/api/v1' //smddc
});
