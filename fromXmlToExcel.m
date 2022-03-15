%将一个全部为xml文件的文件夹中的xml文件转化为excel文件
clc%清除命令行窗口中的所有文本，让屏幕变得干净
clear%从当前工作区中删除所有变量，并将它们从系统内存中释放
%使用时需要更改
videoOrder = 11 ;%对应视频的视频序号
%使用时需要更改
fileNum = 200 ;%文件夹中的xml文件个数
%使用时需要更改
folderOfXml = 'I:\videoDrawFrame\xml_videoDrawFrameFile11';%''内为存放xml文件的文件夹地址
xmlFileFolderObjectNum=0;%文件夹中object总个数初始值，用于后续累加
%使用时需要更改
filename = 'file11.xlsx';%‘’内为Excel文件名称
rowOfExcel=0;%Excel表格行数
lineOfExcel=11;%Excel表格列数
%遍历文件夹中的文件，确定表格的行数
for i = 1 : fileNum
    xmlName = '%d%d.xml';
    xmlName = sprintf(xmlName,videoOrder,i);%将视频序号和循环中的i转换为字符，组成文件名
    xmlFile = xmlread(fullfile(folderOfXml,xmlName));%将文件夹地址和文件名组合成完整的文件路径，并读取
    xmlFileRoot = xmlFile.getDocumentElement();%获取xml文件的根节点
    xmlFileObject = xmlFileRoot.getElementsByTagName('object');%获取xml文件中的object节点集合
    xmlFileObjectNum = xmlFileObject.getLength();%获取object节点的个数
    xmlFileFolderObjectNum=xmlFileFolderObjectNum+xmlFileObjectNum;%将各文件中的object节点个数累加，得到object节点总个数
    rowOfExcel=xmlFileFolderObjectNum+1;%Excel表格行数等于object节点总数加1
end
rangeOfExcel = cell(rowOfExcel,lineOfExcel);%确定Excel表格的范围
%创建表头的文字内容
titleOfExcel={'videoOrder','frameOrder','videoFrameOrder','objectOrder','objectName','objectCX','objectCY','objectW','objectH','objectAngle','remarks'};
rangeOfExcel(1,:)=titleOfExcel;%将表头内容写入表格
rangeOfExcel(2:rowOfExcel,1)={videoOrder};%将视频序号写入表格
%遍历文件夹中的文件，开始写入数据
xmlFileFolderObjectNum=1;%在写入数据时确定表格行序号
for i = 1 : fileNum
    xmlName = '%d%d.xml';
    xmlName = sprintf(xmlName,videoOrder,i);%将视频序号和循环中的i转换为字符，组成文件名
    xmlFile = xmlread(fullfile(folderOfXml,xmlName));%将文件夹地址和文件名组合成完整的文件路径，并读取
    xmlFileRoot = xmlFile.getDocumentElement();%获取单个xml文件中的的根节点
    xmlFileObject = xmlFileRoot.getElementsByTagName('object');%获取单个xml文件中的object节点集合
    xmlFileObjectNum = xmlFileObject.getLength();%获取单个xml文件中的的object节点的个数
    %遍历单个xml文件中的object节点
    for j = 0 : (xmlFileObjectNum-1)
        objectJ=xmlFileObject.item(j);%从object节点的集合中获取第j个objec节点
        objectJName=char(objectJ.item(3).getTextContent());%获取第j个object节点的name属性
        objectJCX=char(objectJ.item(11).item(1).getTextContent());%获取第j个object节点中的cx属性
        objectJCY=char(objectJ.item(11).item(3).getTextContent());%获取第j个object节点中的cy属性
        objectJW=char(objectJ.item(11).item(5).getTextContent());%获取第j个object节点中的w属性
        objectJH=char(objectJ.item(11).item(7).getTextContent());%获取第j个object节点中的h属性
        objectBndboxItemNum=objectJ.item(11).getLength();%获取单个object节点中的bndbox子节点中的属性个数
        if objectBndboxItemNum==11
            objectJAngle=char(objectJ.item(11).item(9).getTextContent());%获取第j个object节点中的angle属性
            objectJRemarks='';%矩形框备注信息文本
        else
            objectJAngle='NONE';%object节点中丢失角度
            objectJRemarks='此数据为矩形框，数据信息为xmin,ymin,xmax,ymax';%矩形框备注信息文本
        end
        xmlFileFolderObjectNum=xmlFileFolderObjectNum+1;%累加以确定写入数据的行序号
        rangeOfExcel(xmlFileFolderObjectNum,2)={i};%写入帧序号
        rangeOfExcel(xmlFileFolderObjectNum,3)={xmlName};%写入xml文件名称
        rangeOfExcel(xmlFileFolderObjectNum,4)={j+1};%写入车辆在帧内的序号，j本身从0开始了，所以需要加1
        rangeOfExcel(xmlFileFolderObjectNum,5)={objectJName};%写入车辆类型
        rangeOfExcel(xmlFileFolderObjectNum,6)={objectJCX};%写入车辆x坐标
        rangeOfExcel(xmlFileFolderObjectNum,7)={objectJCY};%写入车辆y坐标
        rangeOfExcel(xmlFileFolderObjectNum,8)={objectJW};%写入车辆w
        rangeOfExcel(xmlFileFolderObjectNum,9)={objectJH};%写入车辆h
        rangeOfExcel(xmlFileFolderObjectNum,10)={objectJAngle};%写入车辆angle
        rangeOfExcel(xmlFileFolderObjectNum,11)={objectJRemarks};%写入车辆备注信息
    end
end
xlswrite(filename,rangeOfExcel);%将表格信息写入EXCEL文件