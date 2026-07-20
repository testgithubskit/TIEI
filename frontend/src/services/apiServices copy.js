import axios from 'axios';

export const backendApi = axios.create({
    // baseURL: ''
    // baseURL: ''      //Clinets IP TNGA
    // baseURL: ''
    // baseURL: ''  //LOCAL NIHAL DM
    baseURL: 'https://172.18.7.91:8888/api/v1'  //UBUSMC
    // baseURL: '' //Pavi
    // baseURL : ''
    // baseURL : ''   //CLINETS IP GD PLANT
    // baseURL: '' //smddc
});
