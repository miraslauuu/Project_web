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
const body_me = document.getElementById("me");
const body_authors = document.getElementById("authors");

const form_container_p=document.querySelector('.form_container_post');
const iconClose_posts=document.querySelector('.close_button');
const newPostSection = document.getElementById("new_post_section");
const textarea = document.querySelector(".new_post_click");
const cancel_button=document.querySelector('.cancel_button');
const body_post = document.getElementById("posts");
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
    body_me.classList.add('blur');
    body_authors.classList.add('blur');
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
    body_me.classList.remove('blur');
    body_authors.classList.remove('blur');
});
 // =====================code for dropdown=============================

 toggle_button.onclick=function(){
     drop_down_menu.classList.toggle("open");
 };
 xmark_button.onclick=function(){
     drop_down_menu.classList.remove("open");
 };
 //---------------------------Posts-------------------------------------
textarea.addEventListener('click',()=>{
    form_container_p.classList.add('active-popup');
    form_container_p.classList.remove('active');
    newPostSection.style.position="fixed";
     body_post.classList.add('blur');
    newPostSection.style.zIndex = "101";
});
iconClose_posts.addEventListener('click',()=>{
    form_container_p.classList.remove('active-popup');
    newPostSection.style.position="absolute";
    newPostSection.style.zIndex = "";
    body_post.classList.remove('blur');
});
function toggleText(element) {
    element.classList.toggle('expanded');
}
//--------------------------Update posts----------------------------------
const updateDiv = document.querySelector(".update");
const form_container_p_update=document.querySelector('.form_container_post_update');
const iconClose_posts_update=document.querySelector('.close_button_update');
const updatePostSection = document.getElementById("update_post_section");
const blur_section=document.querySelector('.comment');
updateDiv.addEventListener('click',()=>{
    form_container_p_update.classList.add('active-popup');
    form_container_p_update.classList.remove('active');
    updatePostSection.style.position="fixed";
    blur_section.classList.add('blur');
    updatePostSection.style.zIndex = "101";
})
iconClose_posts_update.addEventListener('click',()=>{
    form_container_p_update.classList.remove('active-popup');
    updatePostSection.style.position="absolute";
    updatePostSection.style.zIndex = "";
    blur_section.classList.remove('blur');
});
