import { Slide } from "@mui/material";
// import axios from "axios";
import { forwardRef } from "react";
import { useNavigate } from "react-router-dom";

const getCart = async (setProceed, setCart, authToken) => {
}
const getWishList = async (setProceed, setWishlistData, authToken) => {

}
const handleLogOut = (setProceed, toast, navigate, setOpenAlert) => {
    if (setProceed) {
        localStorage.removeItem('email')
        localStorage.removeItem("role");
        toast.success("Logout Successfully", { autoClose: 500, theme: 'colored' })
        navigate('/')
        setOpenAlert(false)
    }
    else {
        toast.error("User is already logged of", { autoClose: 500, theme: 'colored' })
    }
}

const handleClickOpen = (setOpenAlert) => {
    setOpenAlert(true);
};

const handleClose = (setOpenAlert) => {
    setOpenAlert(false);
};
const getAllProducts = async (setData) => {
}

const getSingleProduct = async (setProduct, id, setLoading) => {
}

const Transition = forwardRef(function Transition(props, ref) {
    return <Slide direction="up" ref={ref} {...props} />;
});





export { getCart, getWishList, handleClickOpen, handleClose, handleLogOut, getAllProducts, getSingleProduct, Transition }