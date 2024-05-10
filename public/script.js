const form_container=document.querySelector('.form_container');
const loginLink=document.querySelector('.login-l');
const registerLink=document.querySelector('.register-l');
const btnPopup=document.querySelector('.login');
const btnPopup2=document.querySelector('.login_dropdown');
const iconClose=document.querySelector('.form_close');
const loginSection= document.querySelector('.login_section');

const toggle_button=document.querySelector('.toggle_btn');
const xmark_button=document.querySelector('.xmark_btn');
const drop_down_menu=document.querySelector('.dropdown_menu');
const body=document.querySelector('html');

registerLink.addEventListener('click',()=>{
    form_container.classList.add('active');
});
loginLink.addEventListener('click',()=>{
    form_container.classList.remove('active');
});
btnPopup.addEventListener('click',()=>{
    form_container.classList.add('active-popup');
    form_container.classList.remove('active');
    loginSection.style.position="fixed";
    loginSection.style.zIndex = "101";
});
btnPopup2.addEventListener('click',()=>{
    form_container.classList.add('active-popup');
    form_container.classList.remove('active');
    loginSection.style.position="fixed";
    loginSection.style.zIndex = "101";
    drop_down_menu.classList.remove("open");
});
iconClose.addEventListener('click',()=>{
    form_container.classList.remove('active-popup');
    loginSection.style.position="absolute";
    loginSection.style.zIndex = "";
});
 // =====================code for dropdown=============================

 toggle_button.onclick=function(){
     drop_down_menu.classList.toggle("open");
 };
 xmark_button.onclick=function(){
     drop_down_menu.classList.remove("open");
 };