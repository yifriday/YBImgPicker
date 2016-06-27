# YBImgPicker
//使用方法：
   
    YBImgPickerViewController * next = [[YBImgPickerViewController alloc]initWithChoosenImgDic:choosenDic delegate:self];
    [next showInViewContrller:self];
    //直接创建，调用显示方法
    

//回调：
- (void)YBImagePickerDidFinishWithImages:(NSDictionary *)choosenImgDic {
    choosenDic = choosenImgDic.mutableCopy;
    //返回的是选中的图片的dictionary，key为asset，value为uiimage
}
