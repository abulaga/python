$PBExportHeader$w_im340.srw
$PBExportComments$�i�f�h�f�@�~
forward
global type w_im340 from w_sh_datawindow
end type
type tab_1 from tab within w_im340
end type
type tabpage_1 from userobject within tab_1
end type
type dw_1 from uo_datawindow within tabpage_1
end type
type dw_qry from uo_dwqry within tabpage_1
end type
type st_h1 from vo_h1 within tabpage_1
end type
type tabpage_1 from userobject within tab_1
dw_1 dw_1
dw_qry dw_qry
st_h1 st_h1
end type
type tabpage_2 from userobject within tab_1
end type
type dw_13 from datawindow within tabpage_2
end type
type dw_3 from uo_datawindow within tabpage_2
end type
type st_h2 from vo_h1 within tabpage_2
end type
type dw_2 from uo_datawindow within tabpage_2
end type
type tabpage_2 from userobject within tab_1
dw_13 dw_13
dw_3 dw_3
st_h2 st_h2
dw_2 dw_2
end type
type tabpage_3 from userobject within tab_1
end type
type dw_12 from uo_datawindow within tabpage_3
end type
type dw_11 from uo_datawindow within tabpage_3
end type
type dw_10 from uo_datawindow within tabpage_3
end type
type dw_6 from uo_datawindow within tabpage_3
end type
type dw_5 from uo_dwenter within tabpage_3
end type
type dw_4 from uo_dwqry within tabpage_3
end type
type st_v3 from vo_v1 within tabpage_3
end type
type st_h3 from vo_h1 within tabpage_3
end type
type tabpage_3 from userobject within tab_1
dw_12 dw_12
dw_11 dw_11
dw_10 dw_10
dw_6 dw_6
dw_5 dw_5
dw_4 dw_4
st_v3 st_v3
st_h3 st_h3
end type
type tabpage_4 from userobject within tab_1
end type
type dw_9 from uo_datawindow within tabpage_4
end type
type dw_8 from uo_dwenter within tabpage_4
end type
type dw_7 from uo_dwqry within tabpage_4
end type
type st_h4 from vo_h1 within tabpage_4
end type
type st_v4 from vo_v1 within tabpage_4
end type
type tabpage_4 from userobject within tab_1
dw_9 dw_9
dw_8 dw_8
dw_7 dw_7
st_h4 st_h4
st_v4 st_v4
end type
type tab_1 from tab within w_im340
tabpage_1 tabpage_1
tabpage_2 tabpage_2
tabpage_3 tabpage_3
tabpage_4 tabpage_4
end type
end forward

global type w_im340 from w_sh_datawindow
string tag = "/DEFOBJECT=dw_2;"
integer width = 2953
integer height = 1732
tab_1 tab_1
end type
global w_im340 w_im340

type variables
string is_doc,is_xuser,is_xpwd,is_cmp,is_type,is_web, is_id, is_use0001, is_pri, is_pritp,is_britp,is_use0018
string is_use0005,is_use0008,is_must_re,is_del_docid,is_use0019,is_use0015
long il_errrow
integer il_tab[9,50],il_cno[]
datetime idt_1
decimal in_taxrate,in_max,in_ubn5
integer ii_max
boolean ib_del_master = false
nvo_drug	invo_drug
nvo_scm invo_scm
end variables

forward prototypes
public function long wf_chk_ok (string as_rpno)
public function long wf_chk_cancel (string as_rpno)
public subroutine wf_avgcost (string as_a[], decimal an_a[], string as_item, string as_cont)
public function decimal wf_get_inprice (long al_row)
public subroutine wf_add_detail ()
public subroutine wf_chk_qty (string as_rpno)
public subroutine wf_sum ()
public function string wf_check_modify_m ()
public function string wf_check_modify_d ()
public function integer wf_save_check ()
public subroutine wf_check_inv_dw2 (long al_row)
public subroutine wf_sum_inv ()
end prototypes

public function long wf_chk_ok (string as_rpno);//2004.04.30
//�ǤJ�t�Ӷi�h�f�渹, �^�Ǹӳ渹���ֳ浧��
long	ll_cnt

select count(*) into :ll_cnt 
		from im550,im500 
		where im500.rp_no = :as_rpno and ( ( im500.rp_no = im550.rp_no ) and  
				( ( im550.in_qty+im550.send_qty > im550.chk_qty ) AND  
				  ( im500.close_yn <> 'Y' ) ) );
return ll_cnt
end function

public function long wf_chk_cancel (string as_rpno);//2004.04.30
//�ǤJ�t�Ӷi�h�f�渹, �^�ǥi�ֳ��٭줧����
long	ll_cnt

select count(*) into :ll_cnt 
		from im550,im500 
		where im500.rp_no = :as_rpno and ( ( im500.rp_no = im550.rp_no ) and  
				( ( im550.chk_qty > 0 ) AND  
				  ( im500.close_yn <> 'Y' ) ) );
return ll_cnt
end function

public subroutine wf_avgcost (string as_a[], decimal an_a[], string as_item, string as_cont);string ls_error,ls_avgcvt,ls_avgcalc,ls_costdif,ls_allhou
decimal ln_cost,ln_costpre,ldc_avg,ldc_s,ln_avg,ln_eoscost
integer li_cnt

ls_avgcalc = f_callfun('sys_all','incost_avgcalc','id',gs_cmp)	//11.�i�f�w�s����������k
ls_costdif = f_callfun('sys_all','in_costdif','id',gs_cmp)	//11-1.�i�f��s�h�ܦ����_

select isnull(set_dismon,0)
	into :ln_costpre
	from pm130
	where cont_id = :as_cont;
if sqlca.sqlcode <> 0 then
	ln_costpre = 100
end if
select isnull(avg_cost,0)
	into :ln_cost
	from pd100
	where item_id = :as_item;
if sqlca.sqlcode <> 0 then
	ln_cost = 0
end if
select isnull(stock,0)
	into :ldc_s
	from pd120
	where item_id = :as_item and hou_no = :as_a[3];
if sqlca.sqlcode <> 0 then
	ldc_s = 0
end if

ln_avg = 0
choose case ls_avgcalc	//�w�s����������k 
	case '1'				//�[�v����
//		ln_avg = (ln_cost * ln_costpre) / 100
//2008.04.16���H�����[���X�������v��A��������, �ӫD����������A�[���X�������v, �X�V���V�p
		if an_a[8] >= 0 then
			if (an_a[8] + an_a[2]) <> 0 then
				ln_avg = ((an_a[8] * an_a[9]) + (an_a[3] * ln_costpre / 100)) / (an_a[8] + an_a[2])
			else
				ln_avg = an_a[9]
			end if
		else
			if an_a[2] <> 0 then 
				ln_avg = (an_a[3] * ln_costpre / 100) / an_a[2]
			else
				ln_avg = an_a[1] * ln_costpre / 100
			end if
		end if
	case '2'				//��i��
		ln_avg = (an_a[1] * ln_costpre) / 100
	case '3'				//��즨��
		if an_a[2] <> 0 then 
			if an_a[3] <> 0 then
				ln_avg = ((an_a[3] / an_a[2]) * ln_costpre) / 100
			elseif an_a[8] + an_a[2] <> 0 then
				ln_avg = (an_a[8] * an_a[9]) / (an_a[8] + an_a[2])
			else
				ln_avg = (an_a[1] * ln_costpre) / 100
			end if
		else
			ln_avg = (an_a[1] * ln_costpre) / 100
		end if
	case '4'				//������
		ln_avg = ln_cost
end choose

//��s�i�f���ӳ�즨��
update im550
	set un_cost = :ln_avg
 where rp_no = :as_a[6] and 
 		 item_id = :as_item ;
if sqlca.sqlcode <> 0 then
	ls_error = sqlca.sqlerrtext
	rollback;
	messagebox('��ưT��','im550(�i�f������) �������� ��s����!~r~n' + ls_error)
	return
end if

//2004.04.14�P�@�ܤ~��spd100��������
select count(1) into :li_cnt from sys100 where id = :as_a[3];
if li_cnt > 0 then
  UPDATE pd100  
	  SET avg_cost = :ln_avg
	WHERE pd100.item_id = :as_item;
	if sqlca.sqlcode <> 0 then
		ls_error = sqlca.sqlerrtext
		rollback;
		messagebox('��ưT��','pd100(�ӫ~�D��) �������� ��s����!~r~n' + ls_error)
		return
	end if
end if

ls_allhou = f_callfun('sys_all','hou_no','id',gs_cmp) //���o�`��
if ls_allhou = gs_cmp then
	//�`��
	ln_eoscost = ln_avg
else
	select eos_cost into :ln_eoscost
	  from pd120
	 where item_id = :as_item
		and hou_no = :ls_allhou;
	if sqlca.sqlcode <> 0 or isnull(ln_eoscost) then ln_eoscost = 0
end if

//�i�f��s�h�ܦ���
if ls_costdif = 'Y' then 
	UPDATE pd120  
		  SET avg_cost = :ln_avg ,
		      eos_cost = :ln_eoscost
		WHERE ( pd120.item_id = :as_item );
	if sqlca.sqlcode <> 0 then
		ls_error = sqlca.sqlerrtext
		rollback;
		messagebox('��ưT��','pd120(�ӫ~�w�s����) �h�ܥ������� ��s����!~r~n' + ls_error)
		return
	end if
else
	UPDATE pd120  
		  SET avg_cost = :ln_avg ,
		      eos_cost = :ln_eoscost
		WHERE ( pd120.item_id = :as_item ) AND  
				( pd120.hou_no = :as_a[3] );
	if sqlca.sqlcode <> 0 then
		ls_error = sqlca.sqlerrtext
		rollback;
		messagebox('��ưT��','pd120(�ӫ~�w�s����) �������� ��s����!~r~n' + ls_error)
		return
	end if
end if

if f_factor_cost(as_a[1],ln_avg,as_a[3],an_a[1]) = 1 then return	//2008.04.16�X�������v���⦨��,�p���筫��s
end subroutine

public function decimal wf_get_inprice (long al_row);decimal	ldc_inprice, ldc_disc, ldc_saprice
string	ls_custid, ls_itemid, ls_mcsno

ls_custid	= idw_2.object.cust_id[idw_2.getrow()]
ls_itemid	= idw_3.object.item_id[al_row]
ls_mcsno		= f_callfun('pd100','mcs_no','item_id',ls_itemid)			//�ӫ~���O

select disc into :ldc_disc from pm121 where cust_id = :ls_custid and mcs_no = :ls_mcsno;
if sqlca.sqlcode < 0 then
	messagebox('�T��','Ū���t�����O��Ƹ�ƿ��~!~r~n' + sqlca.sqlerrtext)
	ldc_inprice = -1
elseif sqlca.sqlcode = 100 then
//	messagebox('�T��','�|���]�w�Ӽt�Ӱӫ~���O���!')
	ldc_inprice = -1
else
	ldc_saprice	= idw_3.object.pd100_sa_price[al_row]
	ldc_inprice = round(ldc_saprice * ldc_disc / 100, 2)
end if

return ldc_inprice
end function

public subroutine wf_add_detail ();string	ls_type
long	ll_r, ll_rows, ll_i

ll_r		= idw_2.getrow()
ll_rows	= gds_1.rowcount()
if ll_r 		= 0 then return
if ll_rows 	= 0 then return

ls_type = idw_2.object.type_id[idw_2.getrow()]
idw_3.setredraw(false)
for ll_r = 1 to ll_rows
	if gds_1.object.cp_chk[ll_r] = 'N' then continue
	
	idw_3.triggerevent("zer_add")
	ll_i = idw_3.rowcount()
	idw_3.object.item_id[ll_i] = gds_1.object.item_id[ll_r]
	idw_3.trigger event itemchanged(ll_i, idw_3.object.item_id, string(gds_1.object.item_id[ll_r]))
	if ls_type = '2' then
		idw_3.object.in_qty[ll_i] = idw_3.object.stock_old[ll_i]
	else
		idw_3.object.in_qty[ll_i] = gds_1.object.in_qty[ll_r]		
	end if
	idw_3.trigger event itemchanged(ll_i, idw_3.object.in_qty, string(idw_3.object.in_qty[ll_i]))
next
idw_3.setredraw(true)
idw_3.setfocus()

end subroutine

public subroutine wf_chk_qty (string as_rpno);long	ll_cnt

select count(*) into :ll_cnt from im500,im550 
	where im550.rp_no = im500.rp_no  and 
			im550.chk_qty > 0 and
			im500.rp_no = :as_rpno;
if isnull(ll_cnt) then ll_cnt = 0			
			
idw_2.object.cp_chk[idw_2.getrow()] = ll_cnt
idw_2.setitemstatus(idw_2.getrow(),0,primary!,notmodified!)
idw_2.setfocus()
idw_2.setcolumn("cmt")

end subroutine

public subroutine wf_sum ();//�p����Y���B
long ll_r,ll_p
decimal ln_in_mon=0,ln_dis_mon = 0,ln_invmon
string ls_inv_sum_yn

idw_2.accepttext()
idw_3.accepttext()
ll_p = idw_2.getrow()
if ll_P = 0 then return
if idw_2.object.ubn3[ll_p] = 1 then
	ls_inv_sum_yn = 'Y'
else
	ls_inv_sum_yn = 'N'
end if

if idw_3.rowcount() > 0 then
	if idw_2.object.rp_no[ll_p] <> idw_3.object.rp_no[1] then return
end if
for ll_r = 1 to idw_3.rowcount()
	ln_in_mon = ln_in_mon + idw_3.object.inmon[ll_r]
	ln_dis_mon = ln_dis_mon + idw_3.object.dis_mon[ll_r]
	ln_invmon = ln_invmon + idw_3.object.inv_in_price[ll_r]
next
ln_in_mon = round(ln_in_mon,0)
ln_invmon = round(ln_invmon,0)
idw_2.object.inmon[ll_p]	= ln_in_mon		//���Y�i�f���B
idw_2.object.dis_mon[ll_p]	= ln_dis_mon	//���Y�馩���B
//2005.06.17�����i�f��ƨϥ�
//if ln_dis_mon > 0 then							//�馩�ʤ���
//	idw_2.object.dis_per[ll_p]	= round((ln_dis_mon / ln_in_mon)*100,2)
//else
//	idw_2.object.dis_per[ll_p]	= 0	
//end if
idw_2.object.tax_mon[ll_p] = f_tax05(round(ln_in_mon - ln_dis_mon,0),idw_2.object.tax_yn[ll_p])
if ls_inv_sum_yn = 'N' then	//�D�o���J�`
	if ln_invmon <> 0 then idw_2.object.other_mon[ll_p] = f_tax05(ln_invmon,idw_2.object.tax_yn[ll_p])
end if

if idw_2.object.tax_yn[ll_p] = '2' then //�~�[
	idw_2.object.notax_mon[ll_p] = round(idw_2.object.inmon[ll_p] - idw_2.object.dis_mon[ll_p],0)
	if ls_inv_sum_yn = 'N' then	//�D�o���J�`
		if ln_invmon <> 0 then idw_2.object.cash_mon[ll_p] = ln_invmon
	end if
else
	idw_2.object.notax_mon[ll_p] = round(idw_2.object.inmon[ll_p] - idw_2.object.dis_mon[ll_p],0) - idw_2.object.tax_mon[ll_p]
	if ls_inv_sum_yn = 'N' then	//�D�o���J�`
		if ln_invmon <> 0 then idw_2.object.cash_mon[ll_p] = ln_invmon - idw_2.object.other_mon[ll_p]
	end if
end if
idw_2.object.ap_mon[ll_p] = idw_2.object.notax_mon[ll_p] + idw_2.object.tax_mon[ll_p]

							 
end subroutine

public function string wf_check_modify_m ();long ll_row
ll_row = idw_2.getrow()
if ll_row = 0 then return 'N'

//��O
if idw_2.GetItemStatus(ll_row, "type_id", Primary!) = DataModified! then return 'Y'
//�w�O
if idw_2.GetItemStatus(ll_row, "hou_no", Primary!) = DataModified! then return 'Y'
//�|�O
if idw_2.GetItemStatus(ll_row, "tax_yn", Primary!) = DataModified! then return 'Y'
//�|�B
if idw_2.GetItemStatus(ll_row, "tax_mon", Primary!) = DataModified! then return 'Y'
//���I���B
if idw_2.GetItemStatus(ll_row, "ap_mon", Primary!) = DataModified! then return 'Y'
////���׽X
//if idw_2.GetItemStatus(ll_row, "close_yn", Primary!) = DataModified! then return 'Y'

return 'N'
end function

public function string wf_check_modify_d ();long ll_row
if idw_3.deletedcount() > 0 then return 'Y'
if idw_3.rowcount() = 0 then return 'N'

for ll_row = 1 to idw_3.rowcount()
	if idw_3.GetItemStatus(ll_row, "in_price", Primary!) = DataModified! then return 'Y'
	if idw_3.GetItemStatus(ll_row, "in_qty", Primary!) = DataModified! then return 'Y'
	if idw_3.GetItemStatus(ll_row, "send_qty", Primary!) = DataModified! then return 'Y'
	if idw_3.GetItemStatus(ll_row, "inmon", Primary!) = DataModified! then return 'Y'
	if idw_3.GetItemStatus(ll_row, "dis_mon", Primary!) = DataModified! then return 'Y'	
next
return 'N'
end function

public function integer wf_save_check ();//�s�ɫe�ˬd�O�_�w�ֳ� 0���ֳ� 1�w�ֳ�
string ls_docid
long	ll_cnt,ll_dtl_cnt

if isnull(is_del_docid) then is_del_docid = ''
if is_del_docid = '' then
	if idw_2.getrow() = 0 then return 0
	ls_docid = idw_2.object.rp_no[idw_2.getrow()]
else
	ls_docid = is_del_docid
end if
//�Y�O�s�W��h���ˬd�O�_�ֳ�A��zer_save�h�߰ݬO�_���s���渹
if idw_2.GetItemStatus(idw_2.getrow(), 0,  Primary!) = NewModified! then return 0

ll_cnt = wf_chk_ok(ls_docid)

select count(*) into :ll_dtl_cnt
from im550 
where rp_no = :ls_docid
and   im550.in_qty+im550.send_qty <> 0;
if isnull(ll_dtl_cnt) then ll_dtl_cnt = 0	
//messagebox(string(ll_cnt)+','+string(ll_dtl_cnt),string(idw_3.deletedcount()))
//���ֳ涵��=0 & �ܤ֤@������
if ll_cnt = 0 and ll_dtl_cnt <> 0 then
	if wf_check_modify_m() = 'Y' or wf_check_modify_d() = 'Y' or is_del_docid <> '' then
		messagebox('�T��','���i�h�f��w�ֳ�Τw���סA���i�s��!~r~n�Э��s�d��!')
		idw_2.object.cp_must_retrieve[idw_2.getrow()] = 'Y'
		idw_2.SetItemStatus(idw_2.getrow(),0,Primary!, NotModified!)
		idw_3.resetupdate()
		is_del_docid = ''
		return 1
	end if
end if
is_del_docid = ''
return 0
end function
public subroutine wf_check_inv_dw2 (long al_row);//�T�{���X�f��O�_�w�J�}�o��
long ll_ubn3 ,ll_ubn3_o
decimal ln_cash_mon ,ln_other_mon
datetime ldt_invdate ,ldt_null
string	ls_invno ,ls_inv_type ,ls_null ,ls_rpno

if al_row = 0 then return
ls_rpno = idw_2.object.rp_no[al_row]
ll_ubn3_o = idw_2.object.ubn3[al_row]

select ubn3 ,inv_no ,inv_date ,inv_type ,cash_mon ,other_mon
into :ll_ubn3 ,:ls_invno ,:ldt_invdate ,:ls_inv_type ,:ln_cash_mon ,:ln_other_mon
from 	im500
where rp_no = :ls_rpno;

//�L[�J�}]���O�S�ܤƴN������s�o�����
if ll_ubn3_o = ll_ubn3 then return

setnull(ldt_null)
setnull(ls_null)

if isnull(ll_ubn3) then ll_ubn3 = 0
if isnull(ls_invno) then ls_invno = ls_null
if isnull(ldt_invdate) then ldt_invdate = ldt_null
if isnull(ls_inv_type) then ls_inv_type = ls_null
if isnull(ln_cash_mon) then ln_cash_mon = 0
if isnull(ln_other_mon) then ln_other_mon = 0

idw_2.object.ubn3[al_row] = ll_ubn3
idw_2.object.inv_no[al_row] = ls_invno
idw_2.object.inv_type[al_row] = ls_inv_type
idw_2.object.inv_date[al_row] = ldt_invdate
idw_2.object.cash_mon[al_row] = ln_cash_mon
idw_2.object.other_mon[al_row] = ln_other_mon

idw_2.SetItemStatus(al_row, "ubn3",Primary!, NotModified!)
idw_2.SetItemStatus(al_row, "inv_no",Primary!, NotModified!)
idw_2.SetItemStatus(al_row, "inv_type",Primary!, NotModified!)
idw_2.SetItemStatus(al_row, "inv_date",Primary!, NotModified!)
idw_2.SetItemStatus(al_row, "cash_mon",Primary!, NotModified!)
idw_2.SetItemStatus(al_row, "other_mon",Primary!, NotModified!)
end subroutine

public subroutine wf_sum_inv ();//�p����Y���B
long ll_r,ll_p
decimal ln_in_mon=0,ln_dis_mon = 0,ln_invmon
string ls_inv_sum_yn

idw_2.accepttext()
idw_3.accepttext()
ll_p = idw_2.getrow()
if ll_P = 0 then return
if idw_2.object.ubn3[ll_p] = 1 then
	ls_inv_sum_yn = 'Y'
else
	ls_inv_sum_yn = 'N'
end if

if idw_3.rowcount() > 0 then
	if idw_2.object.rp_no[ll_p] <> idw_3.object.rp_no[1] then return
end if
for ll_r = 1 to idw_3.rowcount()
	ln_invmon = ln_invmon + idw_3.object.inv_in_price[ll_r]
next
ln_invmon = round(ln_invmon,0)

if ls_inv_sum_yn = 'N' then	//�D�o���J�`
	if ln_invmon <> 0 then idw_2.object.other_mon[ll_p] = f_tax05(ln_invmon,idw_2.object.tax_yn[ll_p])
end if

if idw_2.object.tax_yn[ll_p] = '2' then //�~�[
	if ls_inv_sum_yn = 'N' then	//�D�o���J�`
		if ln_invmon <> 0 then idw_2.object.cash_mon[ll_p] = ln_invmon
	end if
else
	if ls_inv_sum_yn = 'N' then	//�D�o���J�`
		if ln_invmon <> 0 then idw_2.object.cash_mon[ll_p] = ln_invmon - idw_2.object.other_mon[ll_p]
	end if
end if

							 
end subroutine

on w_im340.create
int iCurrent
call super::create
this.tab_1=create tab_1
iCurrent=UpperBound(this.Control)
this.Control[iCurrent+1]=this.tab_1
end on

on w_im340.destroy
call super::destroy
destroy(this.tab_1)
end on

event open;call super::open;string	ls_disp

invo_drug  = create nvo_drug

idw_2.sharedata(idw_1)
tab_1.tabPage_1.dw_qry.setfocus()
tab_1.tabPage_3.dw_4.object.hou_no_fa[1] = gs_cmp
tab_1.tabPage_3.dw_4.object.hou_no_fb[1] = gs_cmp
tab_1.tabPage_4.dw_7.object.hou_no_fa[1] = gs_cmp
tab_1.tabPage_4.dw_7.object.hou_no_fb[1] = gs_cmp

is_id = gs_id
f_chk_parm('0001', is_use0001, ls_disp)
f_chk_parm('0005', is_use0005, ls_disp)
f_chk_parm('0008', is_use0008, ls_disp)
f_chk_parm('0018', is_use0018, ls_disp)	//�o���J�}
f_chk_parm('0019', is_use0019, ls_disp)	//�h�f�u��(�w��)
f_chk_parm('0015', is_use0015, ls_disp)	//e-Hub������걵

in_ubn5 = f_callfun_num('sys_all','ubn6','id',gs_cmp)
if isnull(in_ubn5) then in_ubn5 = 0
is_pritp = f_callfun('sys_all','pm_reqway','id',gs_cmp)
if isnull(is_pritp) then is_pritp = 'Z'
is_britp = f_callfun('sys_all','bk_reqway','id',gs_cmp)
if isnull(is_britp) then is_britp = 'C'
////'0'��'1'�ֳ�/�٭�Ҧ�; '3'���i�٭�
//select privilige into :is_pri from sys_uptree 
//	where id = :gs_id and right(t_data, 5) = 'IM340';
//if is_pri <> '3' then

//	tab_1.tabpage_4.enabled = true
//	idw_2.object.cb_cancel.visible = 'yes'
//else
//	tab_1.tabpage_4.enabled = false
//	idw_2.object.cb_cancel.visible = 'no'	
//	idw_2.object.close_yn.protect = 'yes'
//end if

if uo_variable.this_user_recover = 'Y' then
	tab_1.tabpage_4.enabled = true
else
	tab_1.tabpage_4.enabled = false
	idw_2.object.close_yn.protect = 'yes'
end if

if uo_variable.this_user_check = 'Y' then
	tab_1.tabpage_3.enabled = true
else
	tab_1.tabpage_3.enabled = false
end if

//102.12.05 �u�t�Ӫ����h�νs�v�~��ܲΤ@�s�����
if is_use0008 = 'Y' then 
	idw_2.object.cp_idno.visible		= true
	idw_2.object.cp_idno_t.visible	= true
else
	idw_2.object.cp_idno.visible		= false
	idw_2.object.cp_idno_t.visible	= false
end if

if uo_variable.this_user_ot1 = 'Y' then 
	tab_1.tabpage_2.dw_3.object.cb_9.visible = true
end if

if is_use0018 = 'Y' then
	idw_2.object.cb_inv.visible		= true
else
	idw_2.object.cb_inv.visible		= false
end if

if is_use0019 <> 'Y' then	//�h�f�u��
	idw_2.object.rtn_no_t.visible = false
	idw_2.object.pm100_rtn_type_t.visible = false
	idw_2.object.sub_mon_t.visible = false
	idw_2.object.inv_no2_t.visible = false
	
	idw_2.object.rtn_no.visible = false
	idw_2.object.c_rtn_name.visible = false
	idw_2.object.pm100_rtn_type.visible = false
	idw_2.object.sub_mon.visible = false
	idw_2.object.inv_no2.visible = false
	
	idw_2.object.cb_5.visible = false	//�C�L��
	idw_2.object.cb_send.visible = false	//scm�f��
	idw_2.object.cb_reset.visible = false	//scm�f���٭�
	
	idw_1.object.rtn_no.visible = false
	idw_1.object.inv_no2.visible = false
	idw_1.object.pm100_rtn_type.visible = false
	idw_1.object.pm100_scm_yn.visible = false	
end if

if uo_variable.this_user_ot3 <> 'Y' then	//scm�f���v��
	idw_2.object.cb_send.visible = false
end if
if uo_variable.this_user_ot4 <> 'Y' then 	//scm�f���٭��v��
	idw_2.object.cb_reset.visible = false
end if

if is_use0015 <> 'Y' then	//��ܬO�_������t��
	tab_1.tabPage_1.dw_qry.object.pm100_scm_yn.visible = false
	tab_1.tabPage_1.dw_qry.object.pm100_scm_yn_t.visible = false
	
	idw_2.object.pm100_scm_yn_t.visible = false
	idw_2.object.pm100_scm_yn.visible = false
end if
end event

event close;call super::close;destroy invo_drug
end event

type st_v from w_sh_datawindow`st_v within w_im340
end type

type st_h from w_sh_datawindow`st_h within w_im340
end type

type tab_1 from tab within w_im340
string tag = "FixedOnLeftTop&ScaleToRightBottom"
integer x = 69
integer y = 92
integer width = 2839
integer height = 1676
integer taborder = 10
boolean bringtotop = true
integer textsize = -12
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long backcolor = 12632256
boolean raggedright = true
boolean focusonbuttondown = true
integer selectedtab = 1
tabpage_1 tabpage_1
tabpage_2 tabpage_2
tabpage_3 tabpage_3
tabpage_4 tabpage_4
end type

event constructor;idw_1 = tab_1.tabpage_1.dw_1
idw_2 = tab_1.tabpage_2.dw_2
idw_3 = tab_1.tabpage_2.dw_3

end event

on tab_1.create
this.tabpage_1=create tabpage_1
this.tabpage_2=create tabpage_2
this.tabpage_3=create tabpage_3
this.tabpage_4=create tabpage_4
this.Control[]={this.tabpage_1,&
this.tabpage_2,&
this.tabpage_3,&
this.tabpage_4}
end on

on tab_1.destroy
destroy(this.tabpage_1)
destroy(this.tabpage_2)
destroy(this.tabpage_3)
destroy(this.tabpage_4)
end on

event selectionchanging;if oldindex = 2 then  //leave maintain check
	idw_2.accepttext()
	idw_3.accepttext()
	If (idw_2.modifiedcount() > 0 or idw_2.deletedcount() > 0) or &
		(idw_3.modifiedcount() > 0 or idw_3.deletedcount() > 0) and idw_1.rowcount() > 0 then
		if messagebox("�T������","��Ʀ����ʡA�O�_���s��",question!,okcancel!,1) = 1 then
			if wf_save_check() = 1 then return
			idw_2.triggerevent("zer_save")
			if gb_allsave = false or & 
				tab_1.tabpage_2.dw_2.ib_allsave = false or &
				tab_1.tabpage_2.dw_3.ib_allsave = false then 
				return 1
			end if
		end if
	end if
end if
end event

type tabpage_1 from userobject within tab_1
integer x = 18
integer y = 120
integer width = 2802
integer height = 1540
long backcolor = 67108864
string text = "�i�h�f�d��"
long tabtextcolor = 33554432
string picturename = "Custom038!"
long picturemaskcolor = 16777215
dw_1 dw_1
dw_qry dw_qry
st_h1 st_h1
end type

on tabpage_1.create
this.dw_1=create dw_1
this.dw_qry=create dw_qry
this.st_h1=create st_h1
this.Control[]={this.dw_1,&
this.dw_qry,&
this.st_h1}
end on

on tabpage_1.destroy
destroy(this.dw_1)
destroy(this.dw_qry)
destroy(this.st_h1)
end on

type dw_1 from uo_datawindow within tabpage_1
string tag = "FixedOnLeftHTop&ScaleToRightBottom\\//-++$$-----/qry;/FMTYPE=G;"
integer x = 471
integer y = 828
integer taborder = 20
string title = "�i�h�f��Ƭd��"
string dataobject = "w_im340_d_t1_g"
end type

event constructor;call super::constructor;idwo_share = tab_1.tabpage_2.dw_2


end event

event rowfocuschanged;call super::rowfocuschanged;
if currentrow < 1 then
	return
end if
if currentrow <> idw_2.getrow() then
	idw_2.setrow(currentrow)
	idw_2.scrolltorow(currentrow)
end if

end event

type dw_qry from uo_dwqry within tabpage_1
string tag = "FixedOnLeftTop&ScaleToRightHBottom\\$$-----//---/FIX;/QRY;/NOH;/FMTYPE=F;"
integer x = 151
integer width = 946
integer height = 652
integer taborder = 20
string dataobject = "w_im340_d_qry"
boolean hscrollbar = false
boolean vscrollbar = false
boolean hsplitscroll = false
boolean livescroll = false
end type

event constructor;call super::constructor;idwo_qry = tab_1.tabpage_2.dw_2
//this.object.in_date_fa[1] = datetime(today(),time('00:00:00'))
//this.object.in_date_fb[1] = datetime(today(),time('00:00:00'))
if gs_cmp <> gs_center then
	this.object.hou_no_fa[1] = gs_cmp
	this.object.hou_no_fb[1] = gs_cmp
end if
end event

event buttonclicked;//o
idw_2.reset()
idw_3.reset()
idw_1.reset()
if is_user_read = 'N' then return
super::event buttonclicked(row,actionreturncode,dwo)
if idw_1.rowcount() > 0 then
	idw_1.setfocus()
end if

end event

type st_h1 from vo_h1 within tabpage_1
integer x = 507
integer y = 704
integer height = 44
end type

event constructor;call super::constructor;idrag_u[1] = dw_qry
idrag_d[1] = dw_1
end event

type tabpage_2 from userobject within tab_1
integer x = 18
integer y = 120
integer width = 2802
integer height = 1540
long backcolor = 67108864
string text = "�i�h�f���@"
long tabtextcolor = 33554432
string picturename = "DataManip!"
long picturemaskcolor = 16777215
dw_13 dw_13
dw_3 dw_3
st_h2 st_h2
dw_2 dw_2
end type

on tabpage_2.create
this.dw_13=create dw_13
this.dw_3=create dw_3
this.st_h2=create st_h2
this.dw_2=create dw_2
this.Control[]={this.dw_13,&
this.dw_3,&
this.st_h2,&
this.dw_2}
end on

on tabpage_2.destroy
destroy(this.dw_13)
destroy(this.dw_3)
destroy(this.st_h2)
destroy(this.dw_2)
end on

type dw_13 from datawindow within tabpage_2
boolean visible = false
integer x = 1714
integer y = 1004
integer width = 690
integer height = 400
integer taborder = 21
string title = "none"
string dataobject = "w_im340_d_im110"
boolean livescroll = true
borderstyle borderstyle = stylelowered!
end type

event constructor;this.settransobject(sqlca)

end event

type dw_3 from uo_datawindow within tabpage_2
string tag = "FixedOnLeftHTop&ScaleToRightBottom\\//-++/FMTYPE=G;$$-++++;/ARROWKEY=YES;"
integer x = 622
integer y = 996
integer width = 1029
integer height = 380
integer taborder = 11
string title = "�i�h������"
string dataobject = "w_im340_d_t2_g"
end type

event constructor;call super::constructor;this.idwo_master = dw_2
this.is_mastercolumn[1] = 'rp_no'
this.is_thiscolumn[1] =  'rp_no'
is_lastcolumn = "inv_in_price"
is_firstcolumn = 'item_id'

//2008.11.28
if f_callfun('sys_all','satax_way','id',gs_cmp) = 'Y' then
	if gs_gp_cost <> '' and gs_user_gp <> '' and gs_gp_cost >= gs_user_gp then
		this.object.cb_1.visible = 1
		this.object.cb_3.visible = 1
	else
		this.object.cb_1.visible = 0
		this.object.cb_3.visible = 0
	end if
else
	this.object.cb_1.visible = 1   //�i�f���v�d��
	this.object.cb_3.visible = 1 //�ӫ~���
end if

end event

event itemchanged;call super::itemchanged;string	ls_yn_init,ls_yn,ls_yn_bs,ls_cust,ls_hou,ls_item,ls_null,ls_itemid,ls_custid,ls_name
string	ls_code[],ls_cop_exp,ls_mea,ls_cname,ls_ename,ls_mcs,ls_prd,ls_scode,ls_nhi,ls_fac
string	ls_hmea,ls_funx,ls_notice,ls_shape,ls_color,ls_sideeff,ls_upperid,ls_instruct
string	ls_sqlerrtext,ls_exp2,ls_ubc3,ls_mstno,ls_tmp,ls_ctrlgrd,ls_cmt,ls_uname,ls_ubc4
string	ls_atc_code,ls_med_form,ls_med_class,ls_updis,ls_returnyn,ls_txt,ls_D130, ls_disp
decimal	ln_buyqty,ln_sendqty,ln_saup,ln_qty,ln_mqty,ln_cqty,ln_stock_old,ln_cost_old,ln_store
decimal	ln_uprice,ln_oldprice,ln_pri[],ln_giveper,ln_ubn3,ln_saprice,ldc_selfmon
datetime	ldt_now,ldt_expdate,ldt_today,ldt_in_date

any		la_value[]
integer  li_credis,li_cnt,li_find
decimal	ln1,ln2

//10000.�t�ΰѼƳ]�w.�i�X�f(SYS_ALL)
ls_yn_init	= f_callfun('sys_all','in_sndinit','id',gs_cmp)	//10.�i�f�ذe�Ʊa���
ls_yn			= f_callfun('sys_all','in_upzero','id',gs_cmp)	// 9.�i�f�����0�_
ls_yn_bs		= f_callfun('sys_all','in_buysnd','id',gs_cmp)	// 6.�i�f��s�R�X�e�X�T�{

idw_1.accepttext()

if idw_2.object.cp_must_retrieve[idw_2.getrow()] = 'Y' then	
	messagebox('�T��','���X�f���Ƥw���ʡA�Э��s�d��!')
	return 2
end if

ls_cust = idw_1.object.cust_id[idw_1.getrow()]
ls_hou = idw_2.object.hou_no[idw_2.getrow()]
this.accepttext()
ls_item = this.object.item_id[row]
setnull(ls_null)
choose case dwo.name
	case 'in_price','in_qty','send_qty','give_per'
		if ls_yn = 'N' then
			if this.object.in_price[row] = 0 and this.object.item_id[row] <> 'DISCOUNT' then
				messagebox('�T������','�i�f������i���s!!')
				this.setcolumn('in_price')
				return 1
			end if
		end if
		
		if dwo.name = 'in_qty' or dwo.name = 'send_qty' then
			ls_name = dwo.name
			if dec(data) > 999999 then
				if dwo.name = 'in_qty' then
					ls_txt = '�i�f�q'
				else
					ls_txt = '�ذe�q'
				end if
				Messagebox('�T������',ls_txt+'�W�L999999�I')
				this.setItem(row,ls_name,0)
				return 1
			end if
		end if
		
		if in_ubn5 = 1 then
			this.object.inmon[row] = round(this.object.in_price[row] * this.object.in_qty[row] * &
											 this.object.give_per[row] / 100,0)
		else
			this.object.inmon[row] = this.object.in_price[row] * this.object.in_qty[row] * &
											 this.object.give_per[row] / 100
		end if
		this.object.ap_mon[row] = this.object.inmon[row] - this.object.dis_mon[row]
		if ls_yn_bs = 'Y' then	//�i�f��s�R�X�e�X�T�{
			string ls_qty[]
			ls_qty[1] =  string(this.object.in_qty[row])
			ls_qty[2] =  string(this.object.send_qty[row])
			ls_qty[3] =  string(this.object.in_price[row])	//�i�f��� 2003.03.20
			if dwo.name = 'send_qty' then //2009.02.12 Meg���A����ضq0 ; and this.object.send_qty[row] > 0  then
				OpenWithParm(w_im340_update_pm120, ls_cust + '^' + ls_item + '^' + ls_qty[1] + '^' + ls_qty[2] + '^' + ls_qty[3])
			end if
		end if

		this.object.give_mon[row] = this.object.send_qty[row] * this.object.in_price[row]
		if dwo.name = 'in_qty' then
			if ls_yn_init = 'Y' then	//�i�f�ذe�Ʊa���
				ls_itemid = idw_3.object.item_id[row]
				ls_custid = idw_2.object.cust_id[idw_2.getrow()]
				SELECT   isnull(pm120.buy_qty,0),   isnull(pm120.send_qty,0)
					INTO   :ln_buyqty,   :ln_sendqty  
					FROM pm120
					where pm120.cust_id = :ls_custid and pm120.item_id = :ls_itemid;
				if sqlca.sqlcode <> 0 then
					ln_buyqty = 0
					ln_sendqty = 0
				else
					if ln_buyqty > 0 and ln_sendqty > 0 then
						this.object.send_qty[row] = Truncate ((this.object.in_qty[row] / ln_buyqty),0) * ln_sendqty
					end if
				end if

			end if
		end if
		wf_sum()
		if (this.object.in_qty[row] + this.object.send_qty[row]) > 0 then
			this.object.un_cost[row] = round(this.object.ap_mon[row] / (this.object.send_qty[row] + this.object.in_qty[row]),2)
		end if
	case 'inmon','dis_mon','inv_in_price'
		li_credis = f_callfun_num('sys_all','sc_dayint','id',gs_cmp)
		if isnull(li_credis) then li_credis = 0		
		
		if li_credis = 1 and this.object.inmon[row] > this.object.inv_in_price[row] then
			if this.object.inv_in_price[row] > 0 then
				this.object.dis_mon[row] = this.object.inmon[row] - this.object.inv_in_price[row]
			else
				this.object.dis_mon[row] = 0
			end if
		end if
		if dwo.name = 'inv_in_price' then //����Ҫ��B�Y�S�����ʨ��L���N���n�A�~�򩹤U���h������B�A�_�h�ֳ�L�k�s��
			if this.getitemnumber(row,'dis_mon',Primary!,true) = this.getitemnumber(row,'dis_mon',Primary!,true) then
				this.SetItemStatus(row, "dis_mon", Primary!, NotModified!)
				return 2
			end if
		end if
		
		if dwo.name = 'inmon' then
			//�ק�i�f���Binmon�|�ץ���� in_price 20220725
			this.object.in_price[row]= round(dec(data)/this.object.in_qty[row],3) 
			this.object.give_per[row] = round((dec(data) / (this.object.in_price[row] * this.object.in_qty[row])),2) * 100
		end if
		
		ln1 = this.object.inmon[row]
		ln2 = this.object.dis_mon[row]
		if dwo.name = 'inmon' then ln1 = dec(data)
		if dwo.name = 'dis_mon' then ln2 = dec(data)
		this.object.ap_mon[row] = ln1 - ln2
		if (this.object.in_qty[row] + this.object.send_qty[row]) > 0 then
			this.object.un_cost[row] = round(this.object.ap_mon[row] / (this.object.send_qty[row] + this.object.in_qty[row]),2)
		end if
		wf_sum()
				
	case 'item_id'
		if data <> '' and not isnull(data) then
			//�קK�U�[�ӫ~���X�{��, �~�X�{pop-up window
			this.selecttext(1, len(data))
			this.clear()
			this.object.pd100_cname[row] = ''
			ls_name = f_getitem(row, dwo, data, this)
			//ls_name = f_getitem3(row, dwo, data, this)
			if ls_name = '' then return 1	//�w�U�[
			
			if idw_2.object.type_id[idw_2.getrow()] = '2' then
				ls_returnyn = f_callfun('pd100','return_yn','item_id',data)
				if ls_returnyn = 'N' then
					Messagebox('�t�ΰT��','���ӫ~���i�h�f�I')
					this.object.item_id[row] = ''
					return 1
				end if
			end if
			
			if isnull(ls_name) then 
				if mid(data,1,1) <> '~~' then	//���s�b
					data = f_chk_spchar(data)
					ls_code[1] = 'item_id'
					la_value[1] = data 
					if f_callfun_count('pd100',ls_code,la_value) = 0 and is_user_ot2 = 'N' then	//2018.11.26��L�v���G,���i�s�W�ӫ~			  
						ls_itemid = f_call_pd900(data)
						if ls_itemid = '' then
							return 1
						else
							ls_name = f_callfun('pd100','cname','item_id', ls_itemid)
							this.object.pd100_cname[row] = ls_name
							this.object.item_id[row] = ls_itemid
						end if
					else
						this.object.item_id[row] = ls_null
						this.object.pd100_cname[row] = ls_null
						return 1
					end if
				else	//2006.08.09���O�ķs�W
					ls_itemid = f_call_hs300(mid(data,2))
					if ls_itemid = '' then
						return 1
					else
						if gds_1.dataobject <> 'w_pd100_d_ins_dr120' then 
							return 1
						else
							ls_itemid = gds_1.object.item_id[1]
							data = ls_itemid
	//						this.object.ubc1[row]   = ls_itemid
							ls_cop_exp	= gds_1.object.hs300_use_mem[1]
							ls_mea     	= gds_1.object.mea[1]
							ls_cname   	= gds_1.object.cname[1]
							ls_ename   	= gds_1.object.ename[1]
							ls_mcs     	= gds_1.object.cp_mcsno[1]
							ls_prd 	  	= gds_1.object.prd_cls[1]
							ls_scode   	= gds_1.object.md_scode[1]
							ln_saup    	= gds_1.object.sa_price[1]
							ls_nhi	  	= gds_1.object.hs300_nhi_no[1]
							ls_fac 	  	= gds_1.object.hs300_fac_sname[1]
							ls_hmea 	  	= gds_1.object.hs300_mea[1]
							ln_qty     	= gds_1.object.hs300_pay_mon[1]
							ls_funx	  	= gds_1.object.hs300_function_x[1]
							ls_notice  	= gds_1.object.hs300_notice[1]
							ls_shape   	= gds_1.object.hs300_shape[1]
							ls_color	  	= gds_1.object.hs300_color[1]
							ls_sideeff 	= gds_1.object.hs300_side_eff[1]
							ls_upperid	= gds_1.object.hs300_upper_id[1]
							ls_instruct	= gds_1.object.hs300_instruct[1]
							ls_ubc3		= gds_1.object.hs300_ubc1[1]
							ln_mqty		= gds_1.object.cp_mqty[1]
							ln_cqty		= gds_1.object.cp_cqty[1]
							ls_mstno		= gds_1.object.cp_mstno[1]
							ls_uname		= gds_1.object.cp_uname[1]
							ls_ctrlgrd	= gds_1.object.hs300_ctrl_grd[1]
							ls_atc_code	= gds_1.object.hs300_atc_code[1]
							ls_med_form	= gds_1.object.hs300_med_form[1]
							ls_med_class= gds_1.object.hs300_med_class[1]
							ldt_now    	= datetime(today(),now())
							ls_ubc4 = f_callfun('hs300','ubc2','nhi_no',ls_nhi)
							// 2015.08.19 �s�Wpd130�A������I���쥻�Ӧ�hs300�A���hs300h�A�Huo_variable.this_parm_n[]�ǻ�
							ln_qty = invo_drug.uf_get_pd130_price(ls_nhi, dw_2.object.in_date[dw_2.getrow()])
							
							//2021.11.24 ���Q��14000.D130[�ۥI���B�[������] By Lynn
							f_chk_parm('D130', ls_D130, ls_disp)
							if isnull(ls_D130) then ls_D130 = 'N'
							if ls_D130 = 'Y' then
								select ubn3 into :ln_ubn3 from sys_parm where id = :gs_cmp and parm_no = 'D130';
								if isNull(ln_ubn3) then ln_ubn3 = 100
								if ln_qty > 0 then	
									ldc_selfmon = round(ln_qty * (ln_ubn3 / 100),1)
								else
									select sa_price into :ln_saprice from pd100 where pd100.item_id = :ls_itemid;
									ldc_selfmon = ln_saprice
								end if
							else
								ldc_selfmon = 0
							end if
							
							INSERT INTO pd130
							(	item_id,			cop_exp,			function_x,		brand,			self_mon,
								pay_mon,			cls,				nhi_no,			man_qty,			chd_qty,
								mst_no,			std_qty,			ctrl_grd,		notice,			dc_uname,
								pay_mdate,
								pay_01,								pay_02,								pay_03,
								pay_04,								pay_05,								pay_06,
								pay_07,								pay_08,								pay_09,
								pay_10,								pay_11,								pay_12,
								useday,			inpid,			inptime,			updid,			updtime,
								ubc1,				ubc2,				ubn1,				ubn2,				ubd1,
								ubd2,				cmp_code,		shape,			color,			side_eff,
								upper_id,		instruct,		ubc3,				ubc4,				mcs_no,
								atc_code,		med_form,		med_class	)
							VALUES
							(	:ls_itemid,		:ls_cop_exp,	:ls_funx,		:ls_fac,			:ldc_selfmon,
								:ln_qty,			null,				:ls_nhi,			:ln_mqty,		:ln_cqty,
								:ls_mstno,		:ls_hmea,		:ls_ctrlgrd,	:ls_notice,		:ls_uname,
								:ldt_now,
								:uo_variable.this_parm_n[1],	:uo_variable.this_parm_n[2],	:uo_variable.this_parm_n[3],
								:uo_variable.this_parm_n[4],	:uo_variable.this_parm_n[5],	:uo_variable.this_parm_n[6],
								:uo_variable.this_parm_n[7],	:uo_variable.this_parm_n[8],	:uo_variable.this_parm_n[9],
								:uo_variable.this_parm_n[10],	:uo_variable.this_parm_n[11],	:uo_variable.this_parm_n[12],
								0,					:gs_id,			:ldt_now,		:gs_id,			:ldt_now,
								null,				null,				 0,				0,					null,
								null,				:gs_cmp,			:ls_shape,		:ls_color,		:ls_sideeff,
								:ls_upperid,	:ls_instruct,	:ls_ubc3,		:ls_ubc4,		:ls_mcs,
								:ls_atc_code,	:ls_med_form,	:ls_med_class	);
							if sqlca.sqlcode <>0 then
								ls_sqlerrtext = sqlca.sqlerrtext
								messagebox('�T��', ls_sqlerrtext)
								return 1
							end if
							commit;
							ls_name = f_callfun('pd100','cname','item_id', ls_itemid)
							this.object.pd100_cname[row] = ls_name
							this.object.item_id[row] = ls_itemid
						end if
					end if
				end if
			end if
			data = this.object.item_id[row]
			ls_itemid = data
			this.object.pd100_cname[row] = ls_name
			this.object.pd100_sa_price[row] = f_callfun_num('pd100','sa_price','item_id',data)	//���
			this.object.mea[row] = f_callfun('pd100','mea','item_id',data)	//���
			select  isnull(stock,0), isnull(avg_cost,0), exp_date, loc2,
			        vip_price, par_price, sp_price, ot_price, emp_price, sa_price, avg_cost, in_price
				into :ln_stock_old, :ln_cost_old, :ldt_expdate, :ls_exp2,
				     :ln_pri[1],:ln_pri[2],:ln_pri[3],:ln_pri[4],:ln_pri[5],:ln_pri[6],:ln_pri[7],:ln_pri[8]
				from pd120
				where item_id = :data and
						hou_no = :ls_hou;
			this.object.stock_old[row] = ln_stock_old	//�w�s
			this.object.cost_old[row] 	= ln_cost_old   //�ӫ~�즨��
			this.object.exp_date[row] 	= ldt_expdate	//���Ĥ��	2007.01.24
			this.object.cp_exp1[row]	= ldt_expdate
			this.object.cp_exp2[row]	= ls_exp2	//2007.06.05���Ĥ���G
			this.object.pd100_vip_price[row] = ln_pri[1]
			select sum(isnull(sa430.hou_qty,0) - isnull(sa430.tr_qty,0)) into :ln_store
			from sa430 
			where sa430.item_id = :data and
					sa430.hou_no = :ls_hou;
			this.object.pd100_store[row] = ln_store	//�H�w�ƶq

			ls_custid = idw_2.object.cust_id[idw_2.getrow()]
			//2008.12.26 �P�_�t�Ӧ��ި��ī~�n�O���B���ި��ī~��,�Ƶ���a�J-�t�Ӻި��ī~�n�O��(��dr590��)
			ls_cmt = this.object.cmt[row]
			if isnull(ls_cmt) then ls_cmt=''
			ls_tmp = f_callfun('pm100','ubc4','cust_id',ls_custid)
			if not(isnull(ls_tmp) or trim(ls_tmp)='') then
				ls_ctrlgrd = f_callfun('pd130','ctrl_grd','item_id',data)
				if not(isnull(ls_ctrlgrd) or trim(ls_ctrlgrd)='') then
					dw_2.object.mno[dw_2.getrow()] = ls_tmp
//					ls_cmt = ls_cmt + ls_tmp
//					this.object.cmt[row] = ls_cmt
				end if
			end if

			//2005.11.23 �i����������	2006.09.07�Ҽ{DISCOUNT
			if is_use0001 = 'Y' and data <> 'DISCOUNT' then
				ln_uprice = wf_get_inprice(row)
			end if	//2005.11.30���]�w���,�h�����i��
			ln_giveper = 100
			if (is_use0001 <> 'Y' or ln_uprice = -1) and data <> 'DISCOUNT' then
				//			�������,			�R�X��,				�e�X��
//				ldt_today = datetime(today(),time('00:00:00'))
				ldt_in_date = dw_2.object.in_date[dw_2.getrow()]
				li_find = 0

				select count(1), min(isnull(supply_pri,0)) into :li_find, :ln_uprice from pm124 
					where item_id=:ls_itemid and sdate <= :ldt_in_date and edate >= :ldt_in_date;
				if li_find > 0 then 
					ls_updis = '1'
				elseif dw_2.object.type_id[dw_2.getrow()]='2' and (is_britp='A' or is_britp='B')  then 
					choose case is_britp
						case 'A'
							ln_uprice = ln_pri[7]
						case 'B'
							ln_uprice = ln_pri[8]
					end choose

				else
					choose case is_pritp
						case 'A'
							ln_uprice = ln_pri[1]
						case 'B'
							ln_uprice = ln_pri[2]
						case 'C'
							ln_uprice = ln_pri[3]
						case 'D'
							ln_uprice = ln_pri[4]
						case 'E'
							ln_uprice = ln_pri[5]
						case 'F'
							ln_uprice = ln_pri[6]
						case 'G'
							ln_uprice = ln_pri[7]
						case 'H'
							ln_uprice = ln_pri[8]
						case 'I'	//2018.02.04 �[�[�����t�Ӵ��g�i�f�̧C��
							SELECT min(pm120.supply_pri) into :ln_uprice
								FROM pm120
								where pm120.item_id = :ls_itemid;
								if sqlca.sqlcode <> 0 then
									ln_uprice = ln_pri[8]
									ln_giveper = 100
								end if
						case else
							if is_use0005='Y' and dw_2.object.type_id[dw_2.getrow()]='1' then
								li_cnt = 0
								SELECT 1,pm123.buy_price 
									INTO :li_cnt, :ln_uprice 
									FROM pm123
									where pm123.hou_no=:gs_cmp
									  and pm123.cust_id = :ls_custid 
									  and pm123.item_id = :ls_itemid;
								if li_cnt = 0 then
									li_cnt = 0
									SELECT 1,pm123.buy_price 
									  INTO :li_cnt, :ln_uprice 
									  FROM pm123
									 where pm123.hou_no=:gs_center
										and pm123.cust_id = :ls_custid 
										and pm123.item_id = :ls_itemid;
									if li_cnt = 0 then
										messagebox('��ưT��','�d�L����ĳ��,���i�i�f!')
										this.object.item_id[row] = ls_null
										this.object.pd100_cname[row] = ls_null
										this.object.in_price[row] = 0
										return 1
									end if
								end if
								if isnull(ln_uprice) then ln_uprice = 0
								ln_giveper = 100
							else
								SELECT pm120.supply_pri,   pm120.buy_qty,   pm120.send_qty  ,isnull(pm120.send_per,100)
								INTO :ln_uprice,   :ln_buyqty,   :ln_sendqty  , :ln_giveper
								FROM pm120
								where pm120.cust_id = :ls_custid and pm120.item_id = :ls_itemid;
								if sqlca.sqlcode <> 0 then
									ln_uprice = 0
									ln_giveper = 100
								end if
							end if
					end choose
				end if
			end if
			if isnull(ln_uprice) then ln_uprice = 0
			this.object.in_price[row] = ln_uprice	//�������(�i�f���)
			this.object.give_per[row] = ln_giveper
			this.object.up_dis[row] = ls_updis	//2018.02.05 �[�[����,����Ϥ�,�S�����^�gpm120

			//�i�f���B = �i�f��� * �i�f���B
			//���I���B = �i�f���B - �馩��
			if in_ubn5 = 1 then
				this.object.inmon[row] = round(this.object.in_price[row] * this.object.in_qty[row] * &
												 this.object.give_per[row] / 100,0)
			else
				this.object.inmon[row] = this.object.in_price[row] * this.object.in_qty[row] * &
												 this.object.give_per[row] / 100
			end if
			this.object.ap_mon[row] = this.object.inmon[row] - this.object.dis_mon[row]
			//��즨�� = ���I���B / (�i�f�q + �ذe�q)
			if (this.object.in_qty[row] + this.object.send_qty[row]) > 0 then
				this.object.un_cost[row] = round(this.object.ap_mon[row] / (this.object.send_qty[row] + this.object.in_qty[row]),2)
			end if
			//2005.06.17����, give_per�����i�f���
//			//�ذe% = �ذe�q / �i�f�q * 100
//			if this.object.in_qty[row] > 0  then
//				this.object.give_per[row] = round((this.object.send_qty[row] /this.object.in_qty[row] ) * 100, 2)
//			end if
			//�ذe���B = �ذe�q * �i�f���
			this.object.give_mon[row] = this.object.send_qty[row] * this.object.in_price[row]
			wf_sum()
			return 2
		end if

	case 'io_code'
		if trim(data) <> '' then
			if dw_2.object.type_id[dw_2.getrow()] = '1' then
				if data <> 'I1' and data <> 'I2' and data <> 'I3' then
					messagebox('�T��','�u�i��J I1�BI2�BI3')
					settext('')
					return 1
				end if
			else
				if data <> 'O5' and data <> 'O6' then
					messagebox('�T��','�u�i��J O5�BO6')
					settext('')
					return 1
				end if
			end if
		end if
end choose
if dwo.name = 'in_price' then
	dw_2.accepttext()
	dw_3.accepttext()
	ln_uprice = this.object.in_price[row]
	ls_itemid = this.object.item_id[row]
	ls_custid = idw_2.object.cust_id[idw_2.getrow()]
	choose case is_pritp
		case 'A','B','C','D','E','F','G','H'
			select in_price into :ln_oldprice
			  from pd120
			 where item_id = :ls_itemid 
				and hou_no = :ls_hou;
		case else
			if is_use0005='Y' and dw_2.object.type_id[dw_2.getrow()]='1' then
				li_cnt = 0
				SELECT 1,pm123.buy_price 
					INTO :li_cnt, :ln_oldprice 
					FROM pm123
					where pm123.hou_no=:gs_cmp
					  and pm123.cust_id = :ls_custid 
					  and pm123.item_id = :ls_itemid;
				if li_cnt = 0 then
					li_cnt = 0
					SELECT 1,pm123.buy_price 
					  INTO :li_cnt, :ln_oldprice 
					  FROM pm123
					 where pm123.hou_no=:gs_center
						and pm123.cust_id = :ls_custid 
						and pm123.item_id = :ls_itemid;
				end if
				if isnull(ln_oldprice) then ln_oldprice = 0
			else
				SELECT pm120.supply_pri
					INTO :ln_oldprice
					FROM pm120
					where pm120.cust_id = :ls_custid and pm120.item_id = :ls_itemid;
			end if
	end choose

	if sqlca.sqlcode <> 0 or isnull(ln_oldprice) then ln_oldprice = 0
	if ln_oldprice > 0 then
		if ln_oldprice < ln_uprice then
			messagebox('�T������','�W�� ' + string(ln_uprice - ln_oldprice,'###,###,##0.00') + ' ��')
		end if
		if ln_oldprice > ln_uprice then
			messagebox('�T������','�U�^ ' + string(ln_oldprice - ln_uprice,'###,###,##0.00') + ' ��')
		end if
	end if
end if
end event

event zer_addrev;//O
THIS.triggerevent("zer_add")
end event

event zer_insert;//O
THIS.triggerevent("zer_add")
end event

event zer_save;//o
string	ls_rpno,ls_itemid
long		ll_cnt

dw_2.accepttext()
this.accepttext()
if dw_3.rowcount() > 0 then
	ls_itemid = dw_3.object.item_id[dw_3.rowcount()]
	if isnull(ls_itemid) or trim(ls_itemid) = '' then
		dw_3.deleterow(dw_3.rowcount())
	end if
end if
dw_2.triggerevent("zer_save")

if dw_2.getrow() = 0 then return

//�w����USER���s�d�ߡA���A���ܫ��s���A�H�K�~���y����ƲV��
if is_must_re = 'Y' then	
	is_must_re = 'N'
	return
end if

ls_rpno = dw_2.object.rp_no[dw_2.getrow()]
if is_user_check = 'Y' then 
	ll_cnt  = wf_chk_ok(ls_rpno)		//�ˬd�|���ֳ浧��
	if ll_cnt < 1 then
		dw_2.object.cb_ok.visible = 'no'
	else
		dw_2.object.cb_ok.visible = 'yes'
	end if
end if

if is_user_recover = 'Y' then 
	ll_cnt = 0
	ll_cnt = wf_chk_cancel(ls_rpno)		//�ˬd�i�ֳ��٭쵧��
	if ll_cnt < 1 then
		dw_2.object.cb_cancel.visible = 'no'
	else
//		if is_pri = '3' then
//			dw_2.object.cb_cancel.visible = 'no'
//		else
			dw_2.object.cb_cancel.visible = 'yes'
//		end if	
	end if
end if


end event

event itemerror;call super::itemerror;//if dwo.name = 'item_id' then
//	messagebox('��ưT��','AAAA')
//end if
return 1
end event

event zer_add;//o
if idw_2.object.cp_must_retrieve[idw_2.getrow()] = 'Y' then
	messagebox('�T��','���X�h�f��w�ֳ�A���i�s��!~r~n�Э��s�d��!')
	return 
end if

if idw_2.getrow()  = 0 then return
super::event zer_add()

if not gb_allsave then	
	idw_2.triggerevent("zer_save")
	if not gb_allsave then return
end if

long ll_r,ll_p ,ll_seq=0

ll_p = this.getrow()
if ll_p = 0 then return

for ll_r = 1 to this.rowcount()
	if this.object.seqno[ll_r] >  ll_seq then
		ll_seq = this.object.seqno[ll_r]
	end if
next

ll_seq ++
this.object.seqno[ll_p] = ll_seq
this.object.give_per[ll_p] = idw_2.object.dis_per[idw_2.getrow()]

end event

event updatestart;call super::updatestart;if gb_allsave = false then return 1


string	ls_itemid,ls_custid,ls_err,ls_explain,ls_hou,ls_yn[],ls_ynz,ls_prdcls,ls_prdcls_new
string	ls_d1, ls_d2, ls_d3, ls_exp2, ls_allhou,ls_invno,ls_chi_des,ls_mea,ls_rpno,ls_pono
string	ls_error,ls_ubc2,ls_typeid,ls_updis,ls_inv_sum_yn
long		ll_r,ll_cnt,ll_seqno,ll_poseq,ll_n
integer	li_cnt
decimal	ln_uprice,ln_buyqty,ln_sendqty,ln_sndper,ln_cost,ln_cost2,ln_eoscost
decimal	ln_inmon,ln_dismon,ldc_avg,ldc_s,ln_avg,ln_dif,ln_per,ln_saprice
decimal	ln_invmon,ln_tax,ll_n2
datetime	ldt_pur,ldt_now,ldt_exp,ldt_purold, ldt_exp1
decimal  ln_vip,ln_par_price,ln_sp,ln_ot,ln_emp,ln_tmp,ln_totmon
integer li_cls

this.accepttext()
idw_2.accepttext()
ls_ynz = f_callfun('sys_all','in_upzero','id',gs_cmp)
ls_hou = idw_2.object.hou_no[idw_2.getrow()]
ls_custid = idw_2.object.cust_id[idw_2.getrow()]
ldt_pur = idw_2.object.in_date[idw_2.getrow()]
ldt_now = datetime(today(),now())
is_id	  = idw_2.object.inpidx[idw_2.getrow()]
ls_invno = idw_2.object.inv_no[idw_2.getrow()]
ls_typeid= idw_2.object.type_id[idw_2.getrow()]
//10000.�t�ΰѼƳ]�w
ls_yn[1] = f_callfun('sys_all','in_chgup','id',gs_cmp)		//8.�i�f��s��������T�{�_
ls_yn[2] = f_callfun('sys_all','in_chgcmp','id',gs_cmp)		//7.�i�f��s�D�t�ӽT�{�_
ls_yn[3] = f_callfun('sys_all','incost_avgcvt','id',gs_cmp)	//5.�i�f������s�ɾ�
ls_yn[4] = f_callfun('sys_all','incost_avgcalc','id',gs_cmp)//11.�i�f�w�s����������k
ls_yn[5] = f_callfun('sys_all','in_costdif','id',gs_cmp)		//11-1.�i�f��s�h�ܦ����_
ls_yn[6] = f_callfun('sys_all','in_buysnd','id',gs_cmp)		//6.�i�f��s�R�X�e�X�T�{

if idw_2.object.ubn3[idw_2.getrow()] = 1 then
	ls_inv_sum_yn = 'Y'
else
	ls_inv_sum_yn = 'N'
end if

if this.rowcount() > 0 then //1st rec ��|�B
	this.object.tax_mon[1] = idw_2.object.tax_mon[idw_2.getrow()]
end if

ls_allhou = f_callfun('sys_all','hou_no','id',gs_cmp) //���o�`��
if ls_inv_sum_yn = 'N' then	//�D�o���J�}
	if ls_invno <> '' then	//�ӫ~���Ӧ�����,�o�����ӧR�����s�g�J
		delete ap310 where type_id = '1' and inv_id = :ls_invno;
		if sqlca.sqlcode <> 0 then
			ls_err = sqlca.sqlerrtext
			rollback;
			messagebox('��ưT��','�o�������ɭ��s�g�J����! ' + ls_err)
			return 1
		end if
	end if
end if


For ll_r = 1 To This.RowCount()
	if this.object.item_id[ll_r] = 'DISCOUNT' then continue	//2006.09.07

	If This.GetItemStatus(ll_r,0,primary!) = NewModified! Or &
	   This.GetItemStatus(ll_r,0,primary!) = DataModified! Then
		
		if ls_ynz = 'N' then
			if this.object.in_price[ll_r] <= 0 AND this.object.item_id[ll_r] <> 'DISCOUNT' then
				rollback;
				messagebox('�T������','�i�f������i���s!!')
				this.ScrollToRow (ll_r)
				this.setcolumn('in_price')
				return 1
			end if
		else
			if this.object.in_price[ll_r] < 0 AND this.object.item_id[ll_r] <> 'DISCOUNT' then
				rollback;
				messagebox('�T������','�i�f������i�p��s!!')
				this.ScrollToRow (ll_r)
				this.setcolumn('in_price')
				return 1
			end if
		end if
		
		if this.object.inmon[ll_r] < 0 AND this.object.item_id[ll_r] <> 'DISCOUNT' then
			rollback;
			messagebox('�T������','�i�f���B���i�p��s!!')
			this.ScrollToRow (ll_r)
			this.setcolumn('inmon')
			return 1
		end if
		
		if f_callfun_count_2('pd100','item_id',this.object.item_id[ll_r]) < 1 then
			rollback;
			this.scrolltorow(ll_r)
			this.selectrow(ll_r,true)
			messagebox("�T������","�ӫ~�N�����~ �L���ӫ~�N�� ,�Э��s��J")
			this.setcolumn('item_id')
			return 1 			
		end if		
		
		ls_itemid 	= this.object.item_id[ll_r]
		ln_uprice 	= this.object.in_price[ll_r]
		ln_buyqty 	= this.object.in_qty[ll_r]
		ln_inmon 	= this.object.inmon[ll_r]
		ln_dismon	= this.object.dis_mon[ll_r]
		ln_sendqty	= this.object.send_qty[ll_r]
		ln_invmon	= this.object.inv_in_price[ll_r]
		ls_updis		= this.object.up_dis[ll_r]
		if isnull(ls_updis) then ls_updis = ''
//		ln_invtax	= idw_2.object.other_mon[idw_2.getrow()]
		if isnull(ln_invmon) then ln_invmon = 0
		//2005.06.17�אּ���
		ln_sndper	= this.object.give_per[ll_r]
		if ln_buyqty = 0 and ln_sendqty = 0 then
			rollback;
			this.scrolltorow(ll_r)
			this.selectrow(ll_r,true)
			messagebox("�T������","�i�f�ƶq���ذe�ƶq���i�P�ɬ� 0 ,�Э��s��J")
			this.setcolumn('in_qty')
			return 1 			
		end if	
//		
//		if isnull(ln_buyqty) or ln_buyqty = 0 or isnull(ln_sendqty) or ln_sendqty = 0 then
//			ln_sndper = 0
//		else
//			ln_sndper = round((ln_sendqty / ln_buyqty) * 100,2) 
//		end if
		//2006.09.07�Ҽ{DISCOUNT
		SELECT count(pm120.item_id), max(pm120.pri_trdate)
			INTO :ll_cnt, :ldt_purold
			FROM pm120
			where pm120.cust_id = :ls_custid and pm120.item_id = :ls_itemid;
		if (sqlca.sqlcode <> 0 or ll_cnt = 0 or isnull(ll_cnt)) and ls_updis <> '1' then
			ls_explain = this.object.cmt[ll_r]
			//2004.05.06
			if ls_yn[6] = 'N' then	//�i�f��s�R�X�e�X���ݽT�{
				INSERT INTO pm120  
					( cust_id,		item_id,   	cmp_itemid,   	supply_pri,	pri_trdate,	send_per,   
					  buy_qty,   	send_qty,   explain,   	  	inpid,   	inptime,   	updid,
					  updtime,    	ubc1,   	 	ubc2,   		ubn1,   		  	ubn2,   		ubd1,
					  ubd2,   		cmp_code )  
				VALUES
					( :ls_custid, 	:ls_itemid, '',				:ln_uprice, :ldt_pur, 	:ln_sndper,   
					  :ln_buyqty, 	:ln_sendqty,:ls_explain,	:is_id, 		:ldt_now, 	:is_id,
					  :ldt_now,	  	null,   		null,   			0,   			0,   			null,
					  null, 			:gs_cmp )  ;
			else	//�ݽT�{, �����L���, ���user�^�Ф���s, �����ݧ�s��L������
				insert into pm120
					( cust_id,		item_id,   	cmp_itemid,   	supply_pri,	pri_trdate,	send_per,   
					  buy_qty,   	send_qty,   explain,   	  	inpid,   	inptime,   	updid,
					  updtime,    	ubc1,   	 	ubc2,   		ubn1,   		  	ubn2,   		ubd1,
					  ubd2,   		cmp_code )  
				VALUES
					( :ls_custid, 	:ls_itemid, '',				:ln_uprice, :ldt_pur, 	100,   
					  0, 				0,				:ls_explain,	:is_id, 		:ldt_now, 	:is_id,
					  :ldt_now,	  	null,   		null,   			0,   			0,   			null,
					  null, 			:gs_cmp )  ;
			end if
			if sqlca.sqlcode <> 0 then
				ls_err = sqlca.sqlerrtext
				rollback;
				messagebox('��ưT��','�t�ӳ���ɷs�W����! ' + ls_err)
				return 1
			end if
		else
			if (isnull(ldt_purold) or ldt_pur > ldt_purold) and ls_updis <> '1' then	//�ݧ�s������ʤ��
				if ls_yn[6] = 'N' then
					update pm120  
						set send_per =  :ln_sndper,
							 buy_qty = :ln_buyqty,
							 send_qty = :ln_sendqty,
							 pri_trdate = :ldt_pur,
							 updid = :is_id,
							 updtime = :ldt_now
						where pm120.cust_id = :ls_custid and pm120.item_id = :ls_itemid;
				else
					update pm120
						set pri_trdate	= :ldt_pur,
							 updid		= :is_id,
							 updtime		= :ldt_now
						where pm120.cust_id	= :ls_custid and pm120.item_id = :ls_itemid;
				end if
				if sqlca.sqlcode <> 0 then
					ls_err = sqlca.sqlerrtext
					rollback;
					messagebox('��ưT��','�t�ӳ���ɧ�s����! ' + ls_err)
					return 1
				end if
			else	//���ݧ�s������ʤ��, ���R�X�e�X���ݽT�{�ɪ�����s
				if ls_yn[6] = 'N' and ls_updis <> '1' then
					update pm120  
						set send_per =  :ln_sndper,
							 buy_qty = :ln_buyqty,
							 send_qty = :ln_sendqty,
							 updid = :is_id,
							 updtime = :ldt_now
						where pm120.cust_id = :ls_custid and pm120.item_id = :ls_itemid;
					if sqlca.sqlcode <> 0 then
						ls_err = sqlca.sqlerrtext
						rollback;
						messagebox('��ưT��','�t�ӳ���ɧ�s����! ' + ls_err)
						return 1

					end if
				end if
			end if
		end if
//		//2010.01.05 �s�W�Χ�sap310
//		if ls_invno <> '' then
//			ll_seqno = this.object.seqno[ll_r]
//			ls_chi_des = trim(left(this.object.pd100_cname[ll_r],30))

//			ls_mea	= this.object.mea[ll_r]
//			ls_rpno	= this.object.rp_no[ll_r]
//			ls_pono	= this.object.po_no[ll_r]
//			ll_poseq	= this.object.po_seq[ll_r]
//			li_cnt = 0
//			select count(1) into :li_cnt from ap310 where type_id = '1' and inv_id = :ls_invno and insp_seq = :ll_seqno;
//			if li_cnt > 0 then
//				if ln_invmon = 0 then
//					delete ap310 where type_id = '1' and inv_id = :ls_invno and insp_seq = :ll_seqno;
//				else
//					update ap310 set item_id = :ls_itemid,	
//											chi_des = :ls_chi_des,
//											mea = :ls_mea,	
//											ex_qty = :ln_buyqty,
//											un_price = :ln_uprice,	
//											un_price1= round(:ln_invmon / :ln_buyqty,2),
//											ex_mon	= :ln_inmon - :ln_dismon,
//											ex_mon1	= :ln_invmon,
//											insp_id	= :ls_rpno,
//											ctrl_id	= :ls_pono,
//											updtime	= getdate(),
//											updid	= :gs_id,
//											ctrl_seq = :ll_poseq
//									where type_id = '1' and inv_id = :ls_invno and insp_seq = :ll_seqno;
//				end if
//				if sqlca.sqlcode <> 0 then
//					ls_error = sqlca.sqlerrtext
//					rollback;
//					messagebox('��ưT��','�o��������(AP310) ��s����!~r~n' + &
//									'�ӫ~: ' + ls_itemid + '~r~n' + ls_error)
//					return 1
//				end if		
//			else
//				if ln_invmon > 0 then
//					select max(inv_seqno) into :ll_n from ap310 where type_id = '1' and inv_id = :ls_invno;
//					if isnull(ll_n) then ll_n = 0
//					ll_n = ll_n + 1
//					insert into ap310
//						(type_id,	inv_id,	item_id,	chi_des,	mea,	ex_qty,	un_price,	un_price1,
//						 ex_mon,	ex_mon1,	insp_id,	ctrl_id,	acc_id,	inv_mon,	unbal_mon,	updtime,
//						 updid,	ubc1,	ubc2,	ubn3,	ubn4,	ubd5,	ubd6,	ap_type,	cmp_code,	inv_seqno,


//						 ctrl_seq,	insp_seq)
//					values('1',	:ls_invno,	:ls_itemid,	:ls_chi_des,	:ls_mea,	:ln_buyqty,	:ln_uprice,	round(:ln_invmon / :ln_buyqty,2),
//							:ln_inmon - :ln_dismon,	:ln_invmon,	:ls_rpno,	:ls_pono,	null,	0,	0,	getdate(),

//							:gs_id,	null,	null,	null,	null,null,null,'1',	:gs_cmp,	:ll_n,
//							:ll_poseq,	:ll_seqno);
//					if sqlca.sqlcode <> 0 then
//						ls_error = sqlca.sqlerrtext
//						rollback;
//						messagebox('��ưT��','�o��������(AP310) �s�W����!~r~n' + &
//										'�ӫ~: ' + ls_itemid + '~r~n' + ls_error)
//						return 1
//					end if		
//				end if
//			end if
//		end if

		ldt_exp = this.object.exp_date[ll_r]
		if trim(string(ldt_exp)) <> '' and ls_typeid = '1' then 	//2007.06.05���Ĥ���G;2016.11.08�i�f�~��s�Ĵ�
			ls_d1 = string(this.object.cp_exp1[ll_r],'yyyymmdd')
			ls_d2 = this.object.cp_exp2[ll_r]
			ls_d3 = string(ldt_exp,'yyyymmdd')
			
			f_exp_date(ls_d1,ls_d2,ls_d3,ldt_exp1,ls_exp2)

			UPDATE pd120  
			SET exp_date = :ldt_exp1,
				 loc2	= :ls_exp2
			WHERE ( pd120.item_id = :ls_itemid ) AND ( pd120.hou_no = :ls_hou );
			if sqlca.sqlcode <> 0 then
				ls_err = sqlca.sqlerrtext
				rollback;
				messagebox('��ưT��','�ӫ~�w�s�� [���Ĥ��] ��s����!~r~n ' + ls_err)
				return 1
			end if
		end if 
		
		//2005.08.12�h�f���ݧ�s����
		if ls_yn[3] = '1' and dw_2.object.type_id[dw_2.getrow()] = '1' then
			select isnull(avg_cost,0), isnull(sa_price,0), prd_cls, isnull(vip_price,0),
			       isnull(par_price,0),isnull(sp_price,0),isnull(ot_price,0),isnull(emp_price,0)
				into :ldc_avg, :ln_saprice, :ls_prdcls,:ln_vip,:ln_par_price,:ln_sp,:ln_ot,:ln_emp
				from pd100
				where item_id = :ls_itemid;
			if sqlca.sqlcode <> 0 then
				ldc_avg = 0
			end if
			select isnull(stock,0)
				into :ldc_s
				from pd120
				where item_id = :ls_itemid and hou_no = :ls_hou;
			if sqlca.sqlcode <> 0 then
				ldc_s = 0
			end if
			ln_avg = 0
			choose case ls_yn[4] 
				case '1'
					if ldc_s >= 0 then	//2007.10.03�w�s�p��s, �����즨��(Meg)
						if (ldc_s + ln_buyqty + ln_sendqty) <> 0 then
							ln_avg = abs( ((ldc_s * ldc_avg) + (ln_inmon - ln_dismon)) / (ldc_s + ln_buyqty + ln_sendqty) )
							//2003.12.02
							if ln_avg = 0 then
								ln_avg = ldc_avg//������
							end if
						else
							ln_avg = ldc_avg
						end if
					else
						if ln_uprice <> 0 then
							if (ln_buyqty + ln_sendqty) <> 0 then 
								ln_avg =  (ln_inmon - ln_dismon) / (ln_buyqty + ln_sendqty)
								//2003.12.02
								if ln_avg = 0 then
									ln_avg = ldc_avg//������
								end if
							end if
						else
							ln_avg = ldc_avg//������
						end if
					end if
				case '2'
					//031108 emma ���0����s
					//ln_avg = ln_uprice
					if ln_uprice <> 0 then
						ln_avg = ln_uprice
					else
						ln_avg = ldc_avg//������
					end if
				case '3'
					//031108 emma ���0����s
					if ln_uprice <> 0 then
						if (ln_buyqty + ln_sendqty) <> 0 then 
							ln_avg =  (ln_inmon - ln_dismon) / (ln_buyqty + ln_sendqty)
							//2003.12.02
							if ln_avg = 0 then
								ln_avg = ldc_avg//������
							end if
						end if
					else
						ln_avg = ldc_avg//������
					end if
				case '4'	//������
					ln_avg = ldc_avg
			end choose
			//2003.12.20
			li_cls = f_callfun_num('sys_all', 'crad_daymsg', 'id', ls_hou)
			if isnull(ln_avg) then ln_avg = 0
			ln_tmp = ln_saprice
			choose case li_cls
				case 1
					ln_tmp = ln_saprice
				case 2
					ln_tmp = ln_vip
				case 3
					ln_tmp = ln_par_price
				case 4
					ln_tmp = ln_sp
				case 5
					ln_tmp = ln_ot
				case 6
					ln_tmp = ln_emp
			end choose
			
			if isnull(ln_tmp) then ln_tmp = 0
			if ln_tmp = 0 then
				ln_per = 0
			else
				ln_dif = ln_tmp - ln_avg
				ln_per = round(ln_dif * 100 / ln_tmp,2)
			end if
			
			SELECT max(pd180.prd_cls)  INTO :ls_prdcls_new  
				FROM pd180  
				WHERE ( pd180.score_st <= :ln_per ) AND ( pd180.score_end >= :ln_per );
			if sqlca.sqlcode <> 0 then
				ls_prdcls_new = ls_prdcls
			end if
			//2004.05.06, 1-4��ݨD18, �D���ܸ�Ƥ���spd100��������
			select count(1) into :ll_cnt from sys100 where id = :ls_hou;
			if ll_cnt > 0 then
				UPDATE pd100  
				  SET avg_cost = :ln_avg,  
						prd_cls = :ls_prdcls_new
				WHERE pd100.item_id = :ls_itemid;
				if sqlca.sqlcode <> 0 then
					ls_err = sqlca.sqlerrtext
					rollback;
					messagebox('��ưT��','pd100(�ӫ~�D��) �������� ��s����!~r~n' + ls_err)
					return 1
				end if
			end if
			
			if ls_allhou = gs_cmp then
				//�`��
				ln_eoscost = ln_avg
			else
				select eos_cost into :ln_eoscost
				  from pd120
				 where item_id = :ls_itemid
				   and hou_no = :ls_allhou;
				if sqlca.sqlcode <> 0 or isnull(ln_eoscost) then ln_eoscost = 0
			end if
			
			//030506
			if ls_yn[5] = 'Y' then
				UPDATE pd120  
					  SET avg_cost = :ln_avg ,
					      eos_cost = :ln_eoscost
					WHERE ( pd120.item_id = :ls_itemid );
				if sqlca.sqlcode <> 0 then
					ls_err = sqlca.sqlerrtext
					rollback;
					messagebox('��ưT��','pd120(�ӫ~�w�s����) �h�ܥ������� ��s����!~r~n' + ls_err)
					return 1
				end if
			else
				UPDATE pd120  
					  SET avg_cost = :ln_avg ,
					      eos_cost = :ln_eoscost
					WHERE ( pd120.item_id = :ls_itemid ) AND  
							( pd120.hou_no = :ls_hou );
				if sqlca.sqlcode <> 0 then
					ls_err = sqlca.sqlerrtext

					rollback;
					messagebox('��ưT��','pd120(�ӫ~�w�s����) �������� ��s����!~r~n' + ls_err)
					return 1
				end if
			end if
			if f_factor_cost(ls_itemid,ln_avg,ls_hou,ln_uprice) = 1 then return 1
										//2003.12.02
			if ls_yn[1] = 'Y' and ln_uprice <> 0 then		//���ݽT�{������s
				  UPDATE pd100  
					  SET in_price = :ln_uprice  
					WHERE pd100.item_id = :ls_itemid;
					if sqlca.sqlcode <> 0 then
						ls_err = sqlca.sqlerrtext
						rollback;
						messagebox('��ưT��','pd100(�ӫ~�D��) ��i�� ��s����!~r~n' + ls_err)
						return 1
					end if
					UPDATE pd120  
						  SET in_price = :ln_uprice  
						WHERE ( pd120.item_id = :ls_itemid ) AND  
								( pd120.hou_no = :ls_hou );
					if sqlca.sqlcode <> 0 then
						ls_err = sqlca.sqlerrtext
						rollback;
						messagebox('��ưT��','pd120(�ӫ~�w�s����)  ��i�� ��s����!~r~n' + ls_err)
						return 1
					end if
					if ls_updis <> '1' then
						UPDATE pm120  
							  SET supply_pri = :ln_uprice,
							      pri_trdate = :ldt_pur
							WHERE ( pm120.cust_id = :ls_custid ) AND  
									( pm120.item_id = :ls_itemid );
						if sqlca.sqlcode <> 0 then
							ls_err = sqlca.sqlerrtext
							rollback;
							messagebox('��ưT��','pm120(�t�ӳ����) ������ ��s����!~r~n' + ls_err)
							return 1
						end if
					end if
			end if
			if ls_yn[2] = 'Y' then
				//2003.12.22 MEG �X�f��i�f
				ls_ubc2 = f_callfun('im110','ubc2','hou_no',ls_hou)	//�w�O�������t�ӫȤ�N��
				if isnull(ls_ubc2) then ls_ubc2 = ''			//�i�f�ܧO�D������,��s�D�n�t��
				if (f_callfun_count_2('im110','hou_no',ls_custid) = 0 and ls_ubc2='') or &
				   (f_callfun_count_2('im110','ubc2',ls_custid) = 0 and ls_ubc2 <> '') then
					UPDATE pd100  
						SET cust_id = :ls_custid  
						WHERE pd100.item_id = :ls_itemid;
					if sqlca.sqlcode <> 0 then
						ls_err = sqlca.sqlerrtext
						rollback;
						messagebox('��ưT��','pd100(�ӫ~�D��)�� �t�ӥN�� ��s����!~r~n' + ls_err)
						return 1
					end if
				end if
			end if
		end if
	end if

	//2010.01.05 �s�W�Χ�sap310  if this.object.inv_type[ll_r] <> '5' then
	//2013.12.05 �o�����Ӫ��ƶq�n�A�[�W�ضq
	if ls_inv_sum_yn = 'N' then	//�D�o���J�}
		if ls_invno <> '' and idw_2.object.inv_type[idw_2.getrow()] <> '5' then
			ls_itemid	= this.object.item_id[ll_r]		// �ӫ~�N��
			ls_chi_des	= trim(left(this.object.pd100_cname[ll_r],30))
			ls_mea		= this.object.mea[ll_r]				// ���
			ln_buyqty 	= this.object.in_qty[ll_r] &	
							+ this.object.send_qty[ll_r] 		// �ƶq + �ضq
			ln_uprice 	= this.object.in_price[ll_r]		// ���
			ln_invmon	= this.object.inv_in_price[ll_r]	// ���Ҫ��B
			ls_rpno		= this.object.rp_no[ll_r]			// �i�h�f�渹
			ll_seqno		= this.object.seqno[ll_r]			// ����
			ls_pono		= this.object.po_no[ll_r]			// ���ʳ渹
			ll_poseq		= this.object.po_seq[ll_r]			// ���ʧǸ�		
			ln_inmon 	= this.object.inmon[ll_r]			// �i�f���B
			ln_dismon	= this.object.dis_mon[ll_r]		// �馩��
	
			if ln_invmon > 0 then
				ll_n = 0
				select max(inv_seqno) into :ll_n from ap310 where type_id = '1' and inv_id = :ls_invno;
				if isnull(ll_n) then ll_n = 0
				ll_n = ll_n + 1
	
				insert into ap310
				(	type_id,		inv_id,		inv_seqno,	item_id,		chi_des,			mea,			ex_qty,
					un_price,	un_price1,	ex_mon,		ex_mon1,		insp_id,			insp_seq,	ctrl_id,
					ctrl_seq,	acc_id,		inv_mon,		unbal_mon,	updtime,			updid,		ubc1,
					ubc2,			ubn3,			ubn4,			ubd5,			ubd6,				ap_type,		cmp_code	)
				values
	
				(	'1',			:ls_invno,	:ll_n,		:ls_itemid,	:ls_chi_des,	:ls_mea,		:ln_buyqty,
					0,				0,				0,				:ln_invmon,	:ls_rpno,		:ll_seqno,	:ls_pono,
					:ll_poseq,	null,			0,				0,				getdate(),		:gs_id,		null,
					null,			null,			null,			null,			null,				'1',			:gs_cmp	);
				if sqlca.sqlcode <> 0 then
					ls_error = sqlca.sqlerrtext
					rollback;
					messagebox('��ưT��','�o��������(AP310) �s�W����!~r~n' + &
												 '�ӫ~: ' + ls_itemid + '~r~n' + ls_error)
					return 1
				end if
			end if
		end if
	end if
next

if ls_inv_sum_yn = 'N' then	////�D�o���J�}
	if ls_invno <> '' then
		ln_tax = idw_2.object.other_mon[idw_2.getrow()]
		ll_n2 = 0
		select min(inv_seqno) into :ll_n2 from ap310 where type_id='1' and inv_id = :ls_invno;
		if ll_n2 > 0 then
			update	ap310
			set		inv_mon		= :ln_tax
			where		type_id		= '1'
			and		inv_id		= :ls_invno
			and		inv_seqno	= :ll_n2;
			if sqlca.sqlcode <> 0 then
				ls_err = sqlca.sqlerrtext
				rollback;
				messagebox('��ưT��','�o��������(ap310) �|�B��s����!~r~n' + ls_err)
				return 1
			end if
	
	//		ln_tax = ln_tax / ll_n	//�C�������u���|�B�ᤧ���|���B
			if idw_2.object.tax_yn[idw_2.getrow()] = '1' then
				ln_totmon = idw_2.object.compute_1[idw_2.getrow()]
				update	ap310
				set		ex_mon1	= ex_mon1 - ((ex_mon1 / :ln_totmon) * :ln_tax),
							ex_mon	= ex_mon1 - ((ex_mon1 / :ln_totmon) * :ln_tax)
				where		type_id	= '1' 
				and		inv_id	= :ls_invno;
//				messagebox('error','error')
				if sqlca.sqlcode <> 0 then
					ls_err = sqlca.sqlerrtext
					rollback;
					messagebox('��ưT��','�o��������(ap310) ���|���B��s����!~r~n' + ls_err)
					return 1
				end if
		
				update	ap310
				set		un_price1	= (ex_mon1 / ex_qty),
							un_price		= (ex_mon1 / ex_qty)
				where		type_id		= '1'
				and		inv_id		= :ls_invno;
				if sqlca.sqlcode <> 0 then
					ls_err = sqlca.sqlerrtext
					rollback;
					messagebox('��ưT��','�o��������(ap310) ���|�����s����!~r~n' + ls_err)
					return 1
				end if
			end if
		end if
	end if
end if

if sqlca.sqlcode = 0 then
	commit;
end if
end event

event zer_dropdown;//o
string ls_col, ls_tag, ls_oldtag, ls_custid, ls_itemid1, ls_itemid2

ls_col = this.GetColumnName()
ls_tag = this.describe(ls_col + ".tag")
ls_oldtag = ls_tag
This.Accepttext()
if ls_col = 'item_id' then
	ls_custid = idw_1.object.cust_id[idw_1.getrow()]
	if is_use0005 = 'Y' and dw_2.object.type_id[dw_2.getrow()]='1' then
		ls_tag = '/DDDW=dddw_pm123_arg^' + ls_custid + ';/DDDWS=1;/DDDWOP=2;'
	else
		if f_callfun_count_2('PM120','cust_id',ls_custid) > 0 then
			ls_tag = '/DDDW=dddw_pm120_arg^' + ls_custid + ';/DDDWS=1;/DDDWOP=2;'
			ls_itemid1 = this.object.item_id[this.getrow()]
		end if
	end if
end if
this.modify(ls_col + ".tag = '" + ls_tag + "'")
super::event zer_dropdown()
if is_use0005 = 'Y' and dw_2.object.type_id[dw_2.getrow()]='1' then
else
	if gds_1.rowcount() < 1 then
		if ls_col = 'item_id' then
			ls_itemid2 = this.object.item_id[this.getrow()]
			if (isnull(ls_itemid1) and isnull(ls_itemid2)) or (ls_itemid1 = ls_itemid2) then
				this.modify(ls_col + ".tag = '" + ls_oldtag + "'")
				super::event zer_dropdown()
			end if
		end if
	end if
end if
this.modify(ls_col + ".tag = '" + ls_oldtag + "'")
end event

event buttonclicked;call super::buttonclicked;string ls_item, ls_custid, ls_rp_no,ls_houno,ls_exp2,ls_qty
dec{3} ldc_saprice,ldc_inprice,ln_stock_old,ln_cost_old,ln_store
datetime	ldt_expdate
nvo_variable	lnvo_variable
str_parm	lstr_parm

choose case dwo.name

	case 'cb_9'
		if this.getrow() = 0 then return
		ls_item = this.object.item_id[this.getrow()]
		OpenWithParm(w_im380_qry, ls_item)
	case 'cb_8'
		if this.getrow() = 0 then return
		ls_item = this.object.item_id[this.getrow()]
		if isnull(ls_item) or ls_item = '' then return
		OpenWithParm(w_im315_stock, ls_item)
	case 'cb_7'
		this.dynamic trigger event zer_key(Key7!,2)
	case 'cb_6'
		dw_2.accepttext()
		this.accepttext()
		if dw_2.getrow() > 0 then
			ls_custid = dw_2.object.cust_id[dw_2.getrow()]
			ls_rp_no = dw_2.object.rp_no[dw_2.getrow()]
			if isnull(ls_custid) or ls_custid = '' then return
			//OpenWithParm(w_im340_t2_copy, ls_custid)
			lstr_parm.s_parm[1] = ls_custid
			lstr_parm.s_parm[2] = ls_rp_no
		
			OpenWithParm(w_im340_t2_copy, lstr_parm)
			

			if gds_1.dataobject <> 'w_im340_d_t2_copy' then return
			
			wf_add_detail()
		end if
		
	case 'cb_help'
	messagebox("����","[Ctrl-1] �i�f���v�d��~r~n" + &
							"[Ctrl-2] �i�f��J~r~n" + &
							"[Ctrl-3] �ӫ~���~r~n" + &
							"[Ctrl-4] ����ܧ�~r~n" + &
							"[Ctrl-5] �X���d��~r~n")

	case 'cb_1'
		this.accepttext()
		if this.getrow() > 0 then
			ls_item = this.object.item_id[this.getrow()]
			if isnull(ls_item) or ls_item = '' then return
			OpenWithParm(w_im340_qry, ls_item)
		end if
	case 'cb_2'
		   if dw_2.rowcount() < 1 then 
				messagebox("�����T��","�i�f�D�ɵL���, ���o��J�i�f����")
				return
			end if 
			string ls_cust,ls_po,ls_d[],ls_err,ls_tmp,ls_ctrlgrd,ls_cmt
			long ll_r,ll_seq,ll_i,ll_first,ll_r2
			datetime ldt_now
			decimal ln_mon

			ls_cust = trim(dw_2.object.cust_id[dw_2.getrow()])
			ls_po = trim(dw_2.object.rp_no[dw_2.getrow()])
			Openwithparm(w_im340_impt,ls_cust)
			if uo_variable.this_parm_s[1]  = "OK" then
				select min(mcs_no) 
				  into :ls_d[1]
					from pd150;
				select min(prd_cls)
				 into :ls_d[2]
				 from pd180;
				 dw_13.retrieve()
				ll_seq =0 
				for ll_r = 1 to this.rowcount()
					if this.object.seqno[ll_r] > ll_seq then ll_seq = this.object.seqno[ll_r] 
				next
				ll_first =  0 
				for ll_r = 1 to gds_1.rowcount()
					ll_i =this.insertrow(0)
					this.object.rp_no[ll_i] = ls_po
					ll_seq ++
					if ll_first = 0 then ll_first = ll_i
					this.object.seqno[ll_i] = ll_seq
					this.object.item_id[ll_i] = gds_1.object.item_id[ll_r]
					this.object.pd100_cname[ll_i] = gds_1.object.pd100_cname[ll_r]
					this.object.in_price[ll_i] = gds_1.object.oom_price[ll_r]
					this.object.in_qty[ll_i] = gds_1.object.oom_amt[ll_r]
					this.object.send_qty[ll_i] = gds_1.object.send_qty[ll_r]
					this.object.mea[ll_i] = gds_1.object.mea[ll_r]
					this.object.cmt[ll_i] = gds_1.object.cmt[ll_r]
					//2008.12.26 �P�_�t�Ӧ��ި��ī~�n�O���B���ި��ī~��,�Ƶ���a�J-�t�Ӻި��ī~�n�O��(��dr590��)
					ls_cmt = this.object.cmt[ll_i]
					if isnull(ls_cmt) then ls_cmt=''
					ls_tmp = f_callfun('pm100','ubc4','cust_id',ls_cust)
					if not(isnull(ls_tmp) or trim(ls_tmp)='') then
						ls_ctrlgrd = f_callfun('pd130','ctrl_grd','item_id',gds_1.object.item_id[ll_r])
						if not(isnull(ls_ctrlgrd) or trim(ls_ctrlgrd)='') then
							ls_cmt = ls_cmt + ls_tmp
						end if
					end if
					this.object.exp_date[ll_i] = gds_1.object.exp_date[ll_r]
					this.object.dis_mon[ll_i] = gds_1.object.dis_mon[ll_r]
					this.object.give_per[ll_i] = 100	//gds_1.object.give_per[ll_r]
					this.object.give_mon[ll_i] = gds_1.object.give_mon[ll_r]
					this.object.close_yn[ll_i] = gds_1.object.close_yn[ll_r]
					this.object.chk_qty[ll_i] = 0	//gds_1.object.chk_qty[ll_r]
					this.object.pd100_sa_price[ll_i] = f_callfun_num('pd100','sa_price','item_id',gds_1.object.item_id[ll_r])	//gds_1.object.pd100_saprice[ll_r]
					this.object.inmon[ll_i] = gds_1.object.oom_mon[ll_r]
					this.object.lotnum[ll_i] = gds_1.object.lotnum[ll_r]
					this.object.ap_mon[ll_i] = gds_1.object.oom_mon[ll_r] - gds_1.object.dis_mon[ll_r]
					this.object.inv_in_price[ll_i] = gds_1.object.oom_mon[ll_r] - gds_1.object.dis_mon[ll_r]
					ls_item = this.object.item_id[ll_i]
					if f_callfun_count_2("pd100","item_id",ls_item) < 1 then 
						//insert pd100
						ldt_now = datetime(today(),now())
						ls_d[3] = this.object.pd100_cname[ll_i]
						ls_d[4] = this.object.mea[ll_i]
						ln_mon = this.object.in_price[ll_i]
						INSERT INTO pd100  
						(item_id   ,mcs_no ,prd_cls,cname    ,mea ,    
						  stock,on_order,allo_qty,req_qty,safe_qty1,safe_qty2,sa_price  ,avg_cost ,   
						 in_price ,vip_price ,par_price  ,sp_price ,ot_price   ,emp_price ,batch_qty,   
						 batch_price,com_per    ,cms_mon    ,dis_per    ,onsale_pay ,
						 dot_give,dot_pay   ,gift_no,inpid ,inptime,updid ,updtime  ,st_code ,cmp_code,
						 hou_no    ,factor,ubc1,ubc2,ubn1,ubn2,ubd1,ubd2 )  
						VALUES 
						(:ls_item,:ls_d[1],:ls_d[2],:ls_d[3]   ,:ls_d[4],  
						 0   ,0        ,0       ,0     ,0        ,0         ,0,0,   
						 0,0,0,0,0,0,0        ,   
						 0          ,0,0,0 ,0,   
						 0      ,0,0   ,:is_id,:ldt_now,:is_id,:ldt_now,0,:gs_cmp,   
						 :gs_cmp,1      ,null,null,0  ,0    ,null,null )  ;
						if sqlca.sqlcode <> 0 then


							ls_err = sqlca.sqlerrtext
							rollback;
							messagebox('�ӫ~�D�� pd100',ls_item + ' �s�W����!' + ls_err)
						else
							commit;
						end if																	
						//insert pd120
						for ll_r2 = 1 to dw_13.rowcount()
							ls_d[5] = dw_13.object.hou_no[ll_r2]
							INSERT INTO pd120  
							(item_id   ,hou_no    ,exp_date   ,stock     ,on_order,
							allo_qty,req_qty,safe_qty1 ,safe_qty2 ,at_poqty ,chg_qty    , 
							 sh_all   ,sh_1,sh_2,sh_3,sh_4,updid ,updtime ,ubc1,ubc2,ubn1,ubn2,ubd1,ubd2,cmp_code  ,
							 sa_price ,avg_cost  ,in_price  ,vip_price ,par_price,sp_price  ,ot_price  ,emp_price  ,
							 batch_qty,batch_price,eos_cost)  
							VALUES 
							(:ls_item,:ls_d[5],null ,0,0,   
							0       ,0      ,0,0,0,0, 
							0   ,0   ,0   ,0   ,0,:is_id,:ldt_now,null,null,0   ,0   ,null,null,:gs_cmp   ,
							0,0,0,0,0,0,0,0,
							0        ,0          ,	0);
							if sqlca.sqlcode <> 0 then
								ls_err = sqlca.sqlerrtext
								rollback;
								messagebox('�ӫ~�w�s������ pd120',ls_item +'--' + ls_d[1]+ ' �s�W����!' + ls_err)
								dw_2.scrolltorow(ll_r)
								dw_2.selectrow(ll_r,true)
								return
							else
								commit;
							end if						
						next	
					else
						ls_houno = idw_2.object.hou_no[idw_2.getrow()]
						select  sa_price,isnull(stock,0), isnull(avg_cost,0), exp_date, loc2
						into :ldc_saprice,:ln_stock_old, :ln_cost_old, :ldt_expdate, :ls_exp2
						from pd120
						where item_id = :ls_item and
								hou_no = :ls_houno;
						if isnull(ldc_saprice) then ldc_saprice = 0
					
						this.object.pd100_sa_price[ll_i] = ldc_saprice
						this.object.stock_old[ll_i] = ln_stock_old	//�w�s
						this.object.cost_old[ll_i] 	= ln_cost_old   //�ӫ~�즨��
						if isnull(this.object.exp_date[ll_i]) then this.object.exp_date[ll_i] = ldt_expdate	//���Ĥ��
						this.object.cp_exp1[ll_i]	= ldt_expdate
						this.object.cp_exp2[ll_i]	= ls_exp2	//���Ĥ���G
						
						select sum(isnull(sa430.hou_qty,0) - isnull(sa430.tr_qty,0)) into :ln_store
							from sa430 
							where sa430.item_id = :ls_item and
									sa430.hou_no = :ls_houno;
							this.object.pd100_store[ll_i] = ln_store	//�H�w�ƶq
					end if
				next
				wf_sum()
				if ll_first > 0 then 
					this.setrow(ll_first)
					this.post scrolltorow(ll_first)
					wf_sum()
				end if
				gds_1.reset()
			end if		
		case 'cb_3'
			this.accepttext()
			if this.getrow() > 0 then
				ls_item = this.object.item_id[this.getrow()]
				if isnull(ls_item) or ls_item = '' then return
				OpenWithParm(w_im310_price, ls_item)

			end if
			
		case 'cb_4'
			if idwo_master.getrow() = 0 then return
			if gs_psw_yn = 'Y' then
				if not f_password_hm() then
					return
				end if
			end if
			lnvo_variable.this_parm_s[1] = idwo_master.object.hou_no[idwo_master.getrow()]
			lnvo_variable.this_parm_s[2] = this.object.item_id[this.getrow()]
			openwithparm(w_im340_chgprice, lnvo_variable)
			if message.stringparm = '1' then	//2005.01.13���ܧ���,���s��ܵe�����
				select sa_price into :ldc_saprice
					from pd120 
					where hou_no = :lnvo_variable.this_parm_s[1] and
							item_id= :lnvo_variable.this_parm_s[2];
				if isnull(ldc_saprice) then ldc_saprice = 0
				this.object.pd100_sa_price[this.getrow()] = ldc_saprice
				this.setitemstatus(this.getrow(), 'pd100_sa_price', primary!, notmodified!)
				if is_use0001 = 'Y' and this.object.chk_qty[this.getrow()] = 0 then
					ldc_inprice = wf_get_inprice(this.getrow())
					if ldc_inprice > -1 then
						this.object.in_price[this.getrow()]	= ldc_inprice
						if this.trigger event itemchanged(this.getrow(), this.object.in_price, string(ldc_inprice)) = 0 then
							messagebox("�T��","�i���w�ܧ�, �аO�o�s��!")
						end if
					end if
				end if
			end if
		case 'cb_5'
			dw_2.accepttext()
			if dw_2.getrow() > 0 then
				ls_cust = dw_2.object.cust_id[dw_2.getrow()]
				if isnull(ls_cust) or ls_cust = '' then return
				OpenWithParm(w_im320_qry2, ls_cust)
			end if
		case 'cb_memo'
			if this.getrow() = 0 then return
			ls_item = this.object.item_id[this.getrow()]
			OpenWithParm(w_im320_pd125, ls_item)
		case 'cb_item'
			//�ӫ~�N��/��ڱ��X/²�X/�~�W/�۽s�X2/�t�ӳf��/���O�N��,���o���T���ӫ~�N��,�Ǧ^�~�W
			messagebox("�ӫ~�˯��e�m�X�ζ���","/�~�W			~r~n" + &
										  "\²�X  ~r~n" + &
										  "@�۽s�X2 ~r~n" + &
										  "~~���O�N�� ~r~n" + &
										  "+�t�ӳf��    ~r~n" + &
										  "1.�ӫ~�N��   ~r~n" + &
										  "2.��ڱ��X  ~r~n" )
end choose

end event

event zer_delete;////o
//This.Object.item_id.dddw.Required = "no"
//super::event zer_delete()
//wf_sum()
//This.Object.item_id.dddw.Required = "yes"

long ll_r,ll_f,ll_t,ll_p,ll_rtn
integer li_type

This.Object.item_id.dddw.Required = "no"

if This.AcceptText() = -1 then return
if this.rowcount() = 0    then return

if idw_2.object.cp_must_retrieve[idw_2.getrow()] = 'Y' then
	messagebox('�T��','���i�h�f��w�ֳ�A���i�s��!~r~n�Э��s�d��!')
	return 
end if

if this.GetSelectedRow(0) > 0 then
	li_type = 1
	ll_f = this.rowcount()
	ll_t = 1
	If messagebox("�R��(" + This.DataObject + ")","�O�_�R�����[High Light]�����?", &
   	question!,okcancel!,2) <>1 then
		This.Object.item_id.dddw.Required = "yes"
		return
	end if
else
	li_type = 2
	ll_r = this.getrow()
	if ll_r = 0 then	return
	If messagebox("�R��(" + This.DataObject + ")","�O�_�R����(" + String(ll_r) + ")�����?", &
		question!,okcancel!,2) <>1 then
		This.Object.item_id.dddw.Required = "yes"
		return
	end if
end if
	
//********	
choose case li_type 
	case 2
		if ib_deletedetail then this.of_deletedetail()
		
		if this.object.chk_qty[ll_r] <> 0 then
			messagebox('��ưT��','�w�ֳ椣�i�R��!')
			This.Object.item_id.dddw.Required = "yes"
			return
		end if
		
		ib_delrow = true
		if this.object.item_id[ll_r] = 'DISCOUNT' then	//2005.06.17
			idw_2.object.ubn2[idw_2.getrow()] = idw_2.object.ubn2[idw_2.getrow()] + &
															this.object.inmon[ll_r]
		end if
		If This.DeleteRow(ll_r) = 1 Then
			ib_delrow = false
			il_this_deleterow = ll_r
		Else
			MessageBox("�R��(" + This.DataObject + ")","�L��ƥi�R��")
			This.Object.item_id.dddw.Required = "yes"
			return
		End If	
		//............Copy Area .................		
	   ll_rtn = wf_save_check()
	   if ll_rtn = 1 then return
		this.triggerevent("zer_save")
		if ib_allsave = false then
			this.of_undelete(il_this_deleterow)
			this.scrolltorow(il_this_deleterow)
			this.selectrow(il_this_deleterow,true)
			this.event rowfocuschanged(il_this_deleterow)
		else
			ll_r = this.getrow()
			if ll_r > 0 then
				this.event rowfocuschanged(this.getrow())
				this.scrolltorow(ll_r)
			end if
		end if
	case 1
		 for ll_p = ll_f to ll_t step -1
			  if this.IsSelected(ll_p) then
				  this.event rowfocuschanged(ll_P)
				  if ib_deletedetail then this.of_deletedetail()
				  
				  if this.object.chk_qty[ll_p] <> 0 then
					 messagebox('��ưT��','�w�ֳ椣�i�R��!')
					 This.Object.item_id.dddw.Required = "yes"
					 return
				  end if
		
		  		  ib_delrow = true
				  if this.object.item_id[ll_p] = 'DISCOUNT' then	//2005.06.17
					  idw_2.object.ubn2[idw_2.getrow()] = idw_2.object.ubn2[idw_2.getrow()] + &
					  												  this.object.inmon[ll_p]
				  end if 
				  If This.DeleteRow(ll_p) = 1 Then 
					  ib_delrow = false
					  il_this_deleterow = ll_p
				  else
					  This.Object.item_id.dddw.Required = "yes"
					  return
				  end if
				  
				  ll_rtn = wf_save_check()
				  if ll_rtn = 1 then return
				  this.triggerevent("zer_save")
				  if ib_allsave = false then
						this.of_undelete(il_this_deleterow)
						this.scrolltorow(il_this_deleterow)
						this.selectrow(il_this_deleterow,true)
						this.event rowfocuschanged(il_this_deleterow)
						This.Object.item_id.dddw.Required = "yes"
						return
				  else
						ll_r = this.getrow()
						if ll_r > 0 then
							this.event rowfocuschanged(this.getrow())
						end if
				  end if
			end if
		 next
end choose

ll_rtn = wf_save_check()
if ll_rtn = 1 then return
wf_sum()
idw_2.triggerevent("zer_save")
This.Object.item_id.dddw.Required = "yes"

end event

event getfocus;//o
integer	li_qry
long		ll_cnt 
string	ls_closeyn = 'N', ls_tag 

ll_cnt = dw_2.getrow()
if ll_cnt > 0 then 
	ls_closeyn = dw_2.object.close_yn[dw_2.getrow()]
	

end if

ls_tag = this.tag	
li_qry = pos(ls_tag,"$$") 
if li_qry > 0 then
	if ls_closeyn = 'Y' then
		ls_tag = replace(ls_tag, li_qry + 2, 5, '-----')
	else
		ls_tag = replace(ls_tag, li_qry + 2, 5, '-++++')
	end if
end if
this.tag = ls_tag

Super::EVENT getfocus()
end event

event zer_key;call super::zer_key;string	ls_item,ls_qty

if keyflags = 2 then
	choose case key
		case KeyZ!
			this.accepttext()
			if this.getrow() > 0 then
				ls_item = this.object.item_id[this.getrow()]
				if isnull(ls_item) or ls_item = '' then return
				OpenWithParm(w_sa310_unit, ls_item+'^2')
				ls_qty = string(truncate(dec(message.stringparm),1))
				this.object.in_qty[this.getrow()] = dec(ls_qty)
				this.post event itemchanged(this.getrow(),this.object.in_qty,ls_qty)
			end if
		case Key1!
			if isvalid(this.object.cb_1) then	
				this.post event buttonclicked(this.getrow(), 0, this.object.cb_1)
			end if
		case Key2!
			if isvalid(this.object.cb_2) then
				this.post event buttonclicked(this.getrow(), 0, this.object.cb_2)
			end if
		case Key3!
			if isvalid(this.object.cb_3) then
				this.post event buttonclicked(this.getrow(), 0, this.object.cb_3)
			end if
		case Key4!
			if isvalid(this.object.cb_4) then
				this.post event buttonclicked(this.getrow(), 0, this.object.cb_4)
			end if
		case Key5!
			if isvalid(this.object.cb_5) then
				this.post event buttonclicked(this.getrow(), 0, this.object.cb_5)
			end if
		case Key6!
			if isvalid(this.object.cb_6) then
				this.post event buttonclicked(this.getrow(), 0, this.object.cb_6)
			end if
		case Key7!
			this.of_import(this.object.item_id, this.object.in_qty,'Y','none')	//2018.05.09 �Ѽ�3:Y �i�s�W�ӫ~
		case Key8!
			this.accepttext()
			if this.getrow() > 0 then
				ls_item = this.object.item_id[this.getrow()]
				if isnull(ls_item) or ls_item = '' then return
				OpenWithParm(w_im340_pd130, ls_item)
			end if
	end choose
end if

end event

event retrieveend;call super::retrieveend;//2005.08.05�w�ֳ椣�i�ק���Y����Ƥγ�ھl�B�馩
//2007.06.05�[���Ĥ���G
long	ll_find,i
string	ls_houno, ls_itemid, ls_exp2
datetime	ldt_expdate

if rowcount = 0 then return

ll_find = this.find("chk_qty <> 0",1,rowcount)
if ll_find > 0 then
	idw_2.object.dis_per.protect = 'yes'
	idw_2.object.ubn2.protect = 'yes'
	idw_2.object.cmt.protect = 'yes'
else
	idw_2.object.dis_per.protect = 'no'
	idw_2.object.ubn2.protect = 'no'
	idw_2.object.cmt.protect = 'no'
end if
ls_houno = idw_2.object.hou_no[idw_2.getrow()]
for i = 1 to rowcount
	ls_itemid = this.object.item_id[i]
	select exp_date, loc2 into :ldt_expdate, :ls_exp2 
		from pd120 
		where item_id = :ls_itemid and hou_no = :ls_houno;
	if sqlca.sqlcode = 0 then
		this.object.cp_exp1[i] = ldt_expdate
		this.object.cp_exp2[i] = ls_exp2
	else
		setnull(ldt_expdate)
		this.object.cp_exp1[i] = ldt_expdate
		this.object.cp_exp2[i] = ''
	end if
	this.SetItemStatus(i, 0, Primary!, NotModified!)
next

end event

type st_h2 from vo_h1 within tabpage_2
integer x = 709
integer y = 908
end type

event constructor;call super::constructor;idrag_u[1] = dw_2
idrag_d[1] = dw_3

end event

type dw_2 from uo_datawindow within tabpage_2
string tag = "FixedOnLeftTop&ScaleToRightHBottom\\//+++/FMTYPE=F;$$-++++/NOH;"
integer x = 9
integer y = 20
integer width = 2386
integer height = 860
integer taborder = 11
boolean bringtotop = true
string title = "�i�h�f�D��"
string dataobject = "w_im340_d_t2_f"
boolean hsplitscroll = false
end type

event constructor;call super::constructor;string ls_color, ls_protect, ls_rpno
long ll_cnt

ls_color = string(gl_color[4])+'~tif( type_id ="2",rgb(255,255,0),if( hou_no <> hou_dest ,255,rgb(255,255,255)))'
this.modify("#1.background.color = '" + ls_color + "'")
ls_protect = '0' + '~tif( close_yn = "Y", 1, 0)'
this.modify("inpid.protect = '" + ls_protect + "'")

ib_share = true
idwo_dsave[1] = tab_1.tabpage_2.dw_3
//
idwo_detail[1]  = dw_3
is_detailcolumn[1,1] = "rp_no"

is_firstcolumn = 'type_id'
is_frozncolumn ="other_mon"
ib_deletedetail = true 

if this.getrow() > 0 then
	ls_rpno = this.object.rp_no[this.getrow()]
	if is_user_check = 'Y' then 
		ll_cnt  = wf_chk_ok(ls_rpno)		//�ˬd�|���ֳ浧��
		if ll_cnt < 1 then
			this.object.cb_ok.visible = 'no'
		else
			this.object.cb_ok.visible = 'yes'
		end if
	end if
	
	if is_user_recover = 'Y' then 
		ll_cnt = 0
		ll_cnt = wf_chk_cancel(ls_rpno)		//�ˬd�i�ֳ��٭쵧��
		if ll_cnt < 1 then
			this.object.cb_cancel.visible = 'no'
		else
			this.object.cb_cancel.visible = 'yes'
		end if
	end if
end if

end event

event itemchanged;call super::itemchanged;string ls_type, ls_closeyn, ls_cust, ls_parm,ls_custid, ls_idno
datetime ldt_1,ldt_inp,ldt_paydate
decimal ln_d1,ln_d2
long	ll_rows, ll_row, ll_cnt,ll_paydays,ll_yy,ll_mm ,ll_rtn

if idw_2.object.cp_must_retrieve[idw_2.getrow()] = 'Y' then	
	messagebox('�T��','���i�f���Ƥw���ʡA�Э��s�d��!')
	return 2
end if

ls_closeyn = this.getitemstring(row, 'close_yn', primary!, true)
if ls_closeyn = 'Y' and (dwo.name <> 'close_yn' and dwo.name <> 'cmt') then
	messagebox('�T������', '�ӱi��ڤw����, �ФŦA�ק��L���!')
	return 2
end if

if dwo.name = 'hou_no' then
	if wf_chk_cancel(this.object.rp_no[row]) > 0 then
		messagebox('�T��','����ڤw���ֳ�, �ФŦA�ק�ܮw!')
		return 2
	end if
	this.object.hou_sour[row] = data
end if	

this.accepttext()
choose case dwo.name
	case 'close_yn'
		if MessageBox('�T��','�O�_�T�w�n�ﵲ�׽X?',Exclamation!, YesNo!, 2) = 1 then			
			this.triggerevent('zer_save')
			return 2	//�קKitemchanged������h����close_yn�����A�ܦ�DataModified!
		else
			if data = 'N' then
				this.object.close_yn[row] = 'Y'
			else
				this.object.close_yn[row] = 'N'
			end if
			return 2
		end if
	case 'in_date'
		ldt_inp = datetime(date(left(data,10)),time('00:00:00'))
		ls_custid = this.object.cust_id[row]
		select ubn1 into :ll_paydays from pm100 where cust_id = :ls_custid;
		if isnull(ll_paydays) then ll_paydays = 0
		//2010.01.05 �I�ڴ���
		ll_yy = year(date(ldt_inp))
		ll_mm = month(date(ldt_inp))
		ll_mm = ll_mm + int(ll_paydays / 30) + 1
		if ll_mm > 12 then 
			ll_yy = ll_yy + 1
			ll_mm = mod(ll_mm,12)
		end if
		ldt_paydate = datetime(relativedate(date(string(ll_yy,'0000') + '/' + string(ll_mm,'00') + '/' + '01'),-1),time('00:00:00'))
		this.object.ubd1[row] = ldt_paydate
		// end of 2010.01.05
	case 'cust_id'
		if trim(data) <> '' and not isnull(data) then
			select count(*) into :ll_cnt from pm100 where cust_id = :data and st_code = 0;
			if isnull(ll_cnt) then ll_cnt = 0
			if ll_cnt = 0 then
				if is_use0008 = 'Y' then
					select count(1) into :ll_cnt from pm101 where idno = :data;
					if ll_cnt > 0 then
						if ll_cnt > 1 then
							openwithparm(w_ap311_idno,data)
							if gds_1.rowcount() <= 0 then return
							ls_cust = gds_1.object.cust_id[1]
						else
							select cust_id into :ls_cust from pm101 where idno = :data;
						end if
						this.object.cust_id[row] = ls_cust
						this.trigger event itemchanged(row, dwo, ls_cust)
						return 2
					end if
				end if
				if ll_cnt = 0 then
					select count(1) into :ll_cnt from pm100 where idno = :data and st_code = 0;
					if isnull(ll_cnt) then ll_cnt = 0
					if ll_cnt = 1 then
						select cust_id into :ls_cust from pm100 where idno = :data and st_code = 0;
					else
						if ll_cnt > 1 then
							ls_parm = '^3^' + data
						else
							ls_parm = '%' + data + '%'
							select count(1) into :ll_cnt from pm100 where cust_scode like :ls_parm and st_code = 0;
							if ll_cnt = 1 then
								select cust_id into :ls_cust from pm100 where cust_scode like :ls_parm and st_code = 0;
							else
								if ll_cnt > 1 then
									ls_parm = '^1^' + ls_parm
								else
									select count(1) into :ll_cnt from pm100 where cname like :ls_parm and st_code = 0;
									if ll_cnt = 1 then
										select cust_id into :ls_cust from pm100 where cname like :ls_parm and st_code = 0;
									elseif ll_cnt > 1 then
										ls_parm = '^2^' + ls_parm
									end if
								end if
							end if
						end if
					end if
				end if
			else
				this.post event itemchanged(row,this.object.in_date,string(this.object.in_date[row],'YYYY/MM/DD'))
				return 0
			end if
			if ll_cnt > 1 then
				openwithparm(w_dddw,'dddw_pm100_arg' + ls_parm )	
				if gds_1.rowcount() < 1 then 
					ll_cnt = 0
				else
					this.object.cust_id[row] = gds_1.object.cust_id[1]
					this.trigger event itemchanged(row, dwo, ls_cust)
					return 2
				end if
			elseif ll_cnt = 1 then
				this.object.cust_id[row] = ls_cust
				this.trigger event itemchanged(row, dwo, ls_cust)
				return 2
			else
				ll_cnt = 0
				messagebox("�T��","�d�L���t�Ӹ�� �� �w����! ")
				this.object.cust_id[row] = ''
				this.object.pm100_sname[row] = ''
				return 1
			end if
		end if
	case 'cp_idno'	//�Τ@�s�� ("�t�Ӫ����h�νs"�~���)
		if trim(data) = '' then return

		// �ˬd�Τ@�s���O�_�X�k
		if f_check_cmp_id(data,1) <> 1 then
			this.object.cp_idno[row] = ''

			return 1
		end if

		// �Y����J�t�ӽs���A�h�^�g
		ls_cust = this.object.cust_id[row]
		if IsNull(ls_cust) or trim(ls_cust) = '' then
			select count(1) into :ll_cnt from pm100 where idno = :data and st_code = 0;
			if ll_cnt = 1 then
				select cust_id into :ls_cust from pm100 where idno = :data and st_code = 0;
			elseif ll_cnt > 1 then
				openwithparm(w_dddw,'dddw_pm100_arg^3^'+ data)
				if gds_1.rowcount() <= 0 then return
				ls_cust = gds_1.object.cust_id[1]
			elseif ll_cnt = 0 then
				if is_use0008 = 'Y' then
					select count(1) into :ll_cnt from pm101 where idno = :data;
					if ll_cnt = 1 then
						select cust_id into :ls_cust from pm101 where idno = :data;
					elseif ll_cnt > 1 then
						openwithparm(w_ap311_idno,data)
						if gds_1.rowcount() <= 0 then return
						ls_cust = gds_1.object.cust_id[1]
					end if
				end if
			end if

			if ls_cust > '' then
				this.object.cust_id[row] = ls_cust
				this.trigger event itemchanged(row, idw_2.object.cust_id, ls_cust)
			end if
		end if
	case 'dis_per'		//2005.06.17��i��ڧ��
		ll_rows = idw_3.rowcount()
		for ll_row = 1 to ll_rows
			idw_3.object.give_per[ll_row] = dec(data)
			idw_3.trigger event itemchanged(ll_row, idw_3.object.give_per, data)
		next
	case 'ubn2'		//��i��ڳ̫�馩
		if isnull(data) then this.object.ubn2[row] = 0
		ll_row = idw_3.find("item_id = 'DISCOUNT'", 1, idw_3.rowcount())
		if isnull(data) or integer(data) = 0 then
			if ll_row > 0 then
				idw_3.setrow(ll_row)
				idw_3.triggerevent("zer_delete")
			end if
			return 0
		end if
		if ll_row > 0 then
			idw_3.object.oom_price[ll_row] = 0 - dec(data)

			idw_3.trigger event itemchanged(ll_row, idw_3.object.oom_price, string(0 - dec(data)))
		else
			idw_3.triggerevent("zer_add")
			ll_row = idw_3.rowcount()
			idw_3.object.item_id[ll_row] = 'DISCOUNT'
			idw_3.trigger event itemchanged(ll_row, idw_3.object.item_id, 'DISCOUNT')
			idw_3.object.in_price[ll_row] = 0 - dec(data)
			idw_3.trigger event itemchanged(ll_row, idw_3.object.in_price, string(0 - dec(data)))
			idw_3.object.in_qty[ll_row] = 1
			idw_3.trigger event itemchanged(ll_row, idw_3.object.in_qty, '1')
		end if
		
	case 'tax_yn'
//			this.object.tax_mon[row] = f_tax05(round(this.object.inmon[row] - this.object.dis_mon[row],0),data)
//			if this.object.tax_yn[row] = '2' then //�~�[
//				this.object.notax_mon[row] = round(this.object.inmon[row] - this.object.dis_mon[row],0)
//			else
//				this.object.notax_mon[row] = round(this.object.inmon[row] - this.object.dis_mon[row],0) - this.object.tax_mon[row]
//			end if
//			this.object.ap_mon[row] = this.object.notax_mon[row] + this.object.tax_mon[row]
		wf_sum()
	case 'inv_no'
		  SELECT ap300.inv_type,   ap300.inv_date,   
					ap300.tax_mon,    ap300.pur_mon 
			 INTO :ls_type,        	:ldt_1,   
					:ln_d1,   			:ln_d2  
			 FROM ap300  
			WHERE ( ap300.type_id = '1' ) AND  
					( ap300.inv_id = :data )   ;
		  if sqlca.sqlcode  = 0 then
				this.object.inv_date[row] = ldt_1
				this.object.inv_type[row] = ls_type
				this.object.cash_mon[row] = ln_d2
				this.object.other_mon[row] = ln_d1
		  end if
		  if trim(data) <> '' then	//2010.01.06 �Y�o�����X������,�h�w�a���Ҫ��B�P�i�f���B�ۦP
				for ll_row = 1 to idw_3.rowcount()
					if idw_3.object.inv_in_price[ll_row] = 0 then
						idw_3.object.inv_in_price[ll_row] = idw_3.object.inmon[ll_row]
					end if
				next
			end if
end choose
end event

event updatestart;call super::updatestart;if gb_allsave = false then return 1
long 		ll_r, i ,ll_cnt ,ll_dtl_cnt 
datetime ldt_today, ldt_in, ldt_d1, ldt_d2, ldt_now, ldt_close
string 	ls_col[], ls_val[], ls_err, ls_hou, ls_invfmt ,ls_val_o[]
string 	ls_d[],ls_rpno,ls_inv_sum_yn
decimal	ln_d[]
dwitemstatus	ldw_status

ldt_today = datetime(today(),time('00:00:00'))
ldt_now = datetime(today(),now())

ls_col[1] = 'type_id'
ls_col[2] = 'inv_id'

if idw_2.getrow() > 0 then
	if idw_2.object.cp_must_retrieve[idw_2.getrow()] = 'Y' then	
		messagebox('�T��','���i�f���Ƥw���ʡA�Э��s�d��!')
		return 1
	end if
end if

if wf_save_check() = 1 then return 1

//ls_rpno = this.object.rp_no[this.getrow()]
//ll_cnt = wf_chk_ok(ls_rpno)
//if is_delete <> 'Y' then
//	select count(*) into :ll_dtl_cnt
//	from im550 where rp_no = :ls_rpno;
//	if isnull(ll_dtl_cnt) then ll_dtl_cnt = 0
//	
//	//���ֳ涵��=0 & �ܤ֤@������
//	if ll_cnt = 0 and ll_dtl_cnt <> 0 then
//		messagebox('�T��','���i�h�f��w�ֳ�A���i�s��!~r~n�Э��s�d��!')
//		is_must_re = 'Y'
//		return 1 
//	end if
//else
//	is_delete = 'N'
//end if

For ll_r = 1 To This.RowCount()	//2015.11.30�ֳ�ɪ��Y���B�|��0
//ll_r = this.getrow()
	if idw_2.object.ubn3[ll_r] = 1 then
		ls_inv_sum_yn = 'Y'
	else
		ls_inv_sum_yn = 'N'
	end if
	ldw_status = this.getitemstatus(ll_r, 0, primary!)

	is_id	= this.object.inpidx[ll_r]
	//�p�Y�����w�i�f��, �h�H�i�f������J���ʤH��
	if ldw_status = NewModified! then this.object.inpidx[ll_r] = is_id
	If ldw_status = NewModified! Or ldw_status = DataModified! Then
		ldt_in = datetime(date(this.object.in_date[ll_r]),time('00:00:00'))
		if ldt_in > ldt_today then
			rollback;
			this.scrolltorow(ll_r)
			this.selectrow(ll_r,true)
			messagebox("�T������","�i�h�f������~, ����j�� ���� ,�Э��s��J")
			this.setcolumn('in_date')
			return 1 			
		end if

		if f_get_close(this.object.hou_no[ll_r],ldt_in)	= -1 then //2010.05.20�q���ˬd�O�_�w�w�s�뵲
			messagebox('�T��','�w���w�s�뵲,���i�A����������!')
			return 1
		end if//end of 2010.05.20

 		//2005.05.23�Ѱ�
//		if DaysAfter( date(ldt_in), date(ldt_today) ) > 366 then
//			this.scrolltorow(ll_r)
//			this.selectrow(ll_r,true)
//			messagebox("�T������","�i�h�f������~, ���o��J�W�L�@�~����� ,�Э��s��J")
//			this.setcolumn('in_date')
//			return 1		
//		end if
	
		if this.object.type_id[ll_r] <> '1'  and this.object.type_id[ll_r] <> '2' then
			rollback;
			this.scrolltorow(ll_r)
			this.selectrow(ll_r,true)
			messagebox("�T������","��O���~,���� 1 �� 2 ,�Э��s��J")
			this.setcolumn('type_id')

			return 1 
		end if
		
		if f_callfun_count_2('pm100','cust_id',this.object.cust_id[ll_r]) < 1 then
			rollback;
			this.scrolltorow(ll_r)
			this.selectrow(ll_r,true)
			messagebox("�T������","�t�ӥN�����~ �L���t�ӥN�� ,�Э��s��J")
			this.setcolumn('cust_id')
			return 1 			
		end if

		// 102.12.05 �u�t�Ӫ����h�νs�v�B����ʿ�J�νs�ɡA�s�ɫe�ˬd���T��
		if is_use0008 = 'Y' and this.object.cp_idno[ll_r] > '' then
			string ls_column[], ls_value[]
			ls_column	= {'cust_id','idno'}
			ls_value		= {this.object.cust_id[ll_r],this.object.cp_idno[ll_r]}
			if f_callfun_count('pm100', ls_column, ls_value) < 1 and &	
				f_callfun_count('pm101', ls_column, ls_value) < 1 then
					rollback;
					this.scrolltorow(ll_r)
					this.selectrow(ll_r,true)
					messagebox("�T������","�t�ӥN���P�Τ@�s���L�k���� ,�Э��s��J")
					this.setcolumn('cp_idno')
					return 1 
			end if
		end if

		if f_callfun_count_2('im110','hou_no',this.object.hou_no[ll_r]) < 1 then
			rollback;
			this.scrolltorow(ll_r)
			this.selectrow(ll_r,true)
			messagebox("�T������","�ܮw�N�����~ �L���ܮw�N�� ,�Э��s��J")
			this.setcolumn('hou_no')
			return 1 			
		end if
		
		if this.object.tax_yn[ll_r] <> '1'  and this.object.tax_yn[ll_r] <> '2' &
		   and this.object.tax_yn[ll_r] <> '3'then
			rollback;
			this.scrolltorow(ll_r)
			this.selectrow(ll_r,true)
			messagebox("�T������","�|���t�N�X���~,���� 1 �� 2 �� 3 ,�Э��s��J")
			this.setcolumn('tax_yn')
			return 1 
		end if
		
		if this.object.tax_yn[ll_r] = '3' and this.object.tax_mon[ll_r] > 0 then
			rollback;
			this.scrolltorow(ll_r)
			this.selectrow(ll_r,true)
			messagebox("�T������","�s�|�v �|�B���� �s  ,�Э��s��J")
			this.setcolumn('tax_yn')
			return 1			
		end if

		if this.object.tax_yn[ll_r] = '1' or this.object.tax_yn[ll_r] = '2' then
			if (this.object.inmon[ll_r] > this.object.dis_mon[ll_r]) and this.object.tax_mon[ll_r] <= 0 then
				rollback;
				this.scrolltorow(ll_r)
				this.selectrow(ll_r,true)
				messagebox("�T������"," �|�B�� �j�� �s  ,�Э��s��J")
				this.setcolumn('tax_yn')
				return 1			
			end if
		end if
		
		if ls_inv_sum_yn = 'N' then //�D�o���|�}
		
			if isnull(this.object.inv_type[ll_r]) = false then
				if this.object.inv_type[ll_r] <> '1'  and this.object.inv_type[ll_r] <> '2' &
					and this.object.inv_type[ll_r] <> '3' and this.object.inv_type[ll_r] <> '4' & 
					and this.object.inv_type[ll_r] <> '9' and this.object.inv_type[ll_r] <> '5' then
					rollback;
					this.scrolltorow(ll_r)
					this.selectrow(ll_r,true)
					messagebox("�T������","�o�����O���~,���� 1 , 2 , 3 , 4 , 5 �� 9  ,�Э��s��J")
					this.setcolumn('inv_type')
					return 1 
				end if
			end if
	
			this.setrow(ll_r)
			if idw_3.rowcount() > 0 then
				if ((this.object.compute_1[ll_r] <> idw_3.object.sum_inv[idw_3.rowcount()] and this.object.tax_yn[ll_r]= '1') or &
					(this.object.cash_mon[ll_r] <> idw_3.object.sum_inv[idw_3.rowcount()] and this.object.tax_yn[ll_r]= '2')) and &
					idw_3.object.sum_inv[idw_3.rowcount()] > 0 then
					if MessageBox("�����T��", '�y�o�����B�z�P�y���Ҫ��B�z�[�`����,�[�`����,�O�_�~��s�ɡH', Exclamation!, OKCancel!, 2) = 2 then
						return 1
					end if
				end if
			end if
	
			//ap300 process
			ls_val[1] = '1'
			ls_val[2] = trim(this.object.inv_no[ll_r] )
			if isnull(ls_val[2]) then ls_val[2] = ''
			if ls_val[2] <> '' then
				ls_d[1]	= this.object.tax_yn[ll_r]
				ls_d[2]	= this.object.inv_type[ll_r]
				ls_d[3]	= this.object.cp_cmp[ll_r]
				ln_d[1]	= this.object.cash_mon[ll_r]
				ln_d[2]	= this.object.other_mon[ll_r]				
				ln_d[3]	= ln_d[1] + ln_d[2]
				ls_hou	= this.object.hou_no[ll_r]
				if isnull(ls_d[3]) or trim(ls_d[3]) = '' then ls_d[3] = f_callfun('im110','ubc1','hou_no',ls_hou)
				ldt_d1	= this.object.inv_date[ll_r]
				if isnull(ldt_d1) then
					rollback;
					this.scrolltorow(ll_r)
	
					this.selectrow(ll_r,true)
					messagebox("�T������"," �Э���J,�o�����")
					this.setcolumn('inv_date')
					return 1						
				end if	
				
				ls_d[4] = this.object.cust_id[ll_r]				
				select	cname,		idno,			adds1
				into		:ls_d[5],	:ls_d[6],	:ls_d[7]
				from		pm100
				where		cust_id = :ls_d[4];
	
				// 102.12.05 �u�t�Ӫ����h�νs�v�B����ʿ�J�νs�ɡA�h�u���ĥ�
				if is_use0008 = 'Y' and (this.object.cp_idno[ll_r]) > '' then
					ls_d[6] = this.object.cp_idno[ll_r]
				end if
	
				if IsNull(ls_d[6]) or trim(ls_d[6]) = '' then
					rollback;
					this.scrolltorow(ll_r)
					this.selectrow(ll_r,true)
					messagebox("�T������"," �Х��ɿ�J pm100(�t�ӥD��),�Τ@�s��,�A�s�J�������" )
					return 1
				end if
				choose case ls_d[2]
					case '1'
						ls_invfmt = '21'
					case '2','9'
						ls_invfmt = '22'
					case '3'
						ls_invfmt = '25'
					case else
						ls_invfmt = '21'
				end choose
				ls_val_o[1] = '1'
				ls_val_o[2] = this.getitemstring(ll_r,'inv_no',Primary!,true)
				
				if f_callfun_count('ap300',ls_col,ls_val) > 0 then				
					//update
					UPDATE ap300  
					  SET tax_code = (case :ls_d[1] when '1' then '1' when '2' then '1' else '2' end),
							inv_type = :ls_d[2] , 
							cmp_cd	= :ls_d[3] ,
							pur_mon  = :ln_d[1] ,
							tax_mon  = :ln_d[2] ,
							inv_amt  = :ln_d[3] ,
							inv_date = :ldt_d1 ,
							inv_fmt = :ls_invfmt,
							cust_id 	= :ls_d[4],		
							inv_name = :ls_d[5],		
							idno 		= :ls_d[6],		
							inv_addr = :ls_d[7],
							updid		= :gs_id,
							updtime	= getdate()
					WHERE ( ap300.type_id = :ls_val[1] ) AND  
							( ap300.inv_id = :ls_val[2] )   ;
					if sqlca.sqlcode <> 0 then
						ls_err = sqlca.sqlerrtext
						rollback;
						this.scrolltorow(ll_r)
						this.selectrow(ll_r,true)
						messagebox("�T������"," ap300(���I�o���D��),���ʿ��~~n~r" + ls_err)
						return 1					
					end if								
				else
					if f_callfun_count('ap300',ls_col,ls_val_o) > 0 then //�ק�o�����X��
						//���R����
						delete ap310 where type_id = '1' and inv_id = :ls_val_o[2];
						if sqlca.sqlcode <> 0 then
							ls_err = sqlca.sqlerrtext
							rollback;
							this.scrolltorow(ll_r)
							this.selectrow(ll_r,true)
							messagebox("�T������"," ap310(���I�o������),�R�����~~n~r" + ls_err)
							return 1					
						end if
						
						//update
						UPDATE ap300  
						  SET inv_id	= :ls_val[2],
								tax_code = (case :ls_d[1] when '1' then '1' when '2' then '1' else '2' end),
								inv_type = :ls_d[2] , 
								cmp_cd	= :ls_d[3] ,
								pur_mon  = :ln_d[1] ,
								tax_mon  = :ln_d[2] ,
								inv_amt  = :ln_d[3] ,
								inv_date = :ldt_d1 ,
								inv_fmt = :ls_invfmt	,
								cust_id 	= :ls_d[4],		
								inv_name = :ls_d[5],		
								idno 		= :ls_d[6],		
								inv_addr = :ls_d[7],
								updid		= :gs_id,
								updtime	= getdate()
						WHERE ( ap300.type_id = :ls_val_o[1] ) AND  
								( ap300.inv_id = :ls_val_o[2] )   ;
						if sqlca.sqlcode <> 0 then
							ls_err = sqlca.sqlerrtext
							rollback;
							this.scrolltorow(ll_r)
							this.selectrow(ll_r,true)
							messagebox("�T������"," ap300(���I�o���D��),���ʿ��~~n~r" + ls_err)
							return 1					
						end if
						
						//�j������ܦ�datamodify ,
						if idw_3.rowcount() > 0 then
							idw_3.object.inv_in_price[1] = idw_3.object.inv_in_price[1] + 1
							idw_3.object.inv_in_price[1] = idw_3.object.inv_in_price[1] - 1
						end if
					else
						if this.object.inv_type[ll_r] <> '5' then
							//insert
							
		
							ldt_d2 = datetime(date(string(ldt_d1,'yyyy/mm')+'/01'),time("00:00:00"))
							INSERT INTO ap300  
							(	type_id,		inv_id,		inv_type,	tax_code,		pro_id,		inv_date,
								cmp_cd,		lose_id,		cust_id,		inv_name,		idno,			inv_addr,
								acc_mon,		pur_mon,		tax_mon,		inv_amt,			issu_user,	issu_time,
								ap_rem_id,	stat_code,	rmk,			inv_sa_perent,	updtime,		updid,
								ubc1,			ubc2,			ubn3,			ubn4,				ubd5,			ubd6,
								tax_no,		cmp_code,	inv_fmt)
							VALUES
							(	:ls_val[1],	:ls_val[2],	:ls_d[2],   (case :ls_d[1] when '1' then '1' when '2' then '1' else '2' end),	'1',	:ldt_d1,  
								:ls_d[3],	null,			:ls_d[4],	:ls_d[5],		:ls_d[6],	:ls_d[7], 					
		
								:ldt_d2,		:ln_d[1],	:ln_d[2],	:ln_d[3],		:gs_id,		:ldt_now, 					
								null,			'10',			null,			100.0,			:ldt_now,	:gs_id, 					
								'Y',			'N',			1,				null,				:ldt_d2,		null, 					
								null,			:gs_cmp,		:ls_invfmt	);
							if sqlca.sqlcode <> 0 then
								ls_err = sqlca.sqlerrtext
								rollback;
								this.scrolltorow(ll_r)
								this.selectrow(ll_r,true)
								messagebox("�T������"," ap300(���I�o���D��),�s�W���~~n~r" + ls_err)
								return 1					
							end if		
						end if
					end if
				end if
			end if
		end if	//�D�o���|�}
	end if
next
end event

event zer_add;//o
long	ll_r
string ls_chi, ls_doc
datetime ldt_today

this.accepttext()

gb_allsave = true
ib_allsave = true
dw_3.ib_allsave = true
super::event zer_add()
this.triggerevent(getfocus!)
//
if gb_allsave and ib_allsave  then
	ll_r = this.getrow()
	if ll_r > 0 then
		ldt_today = datetime(today(),now())
		is_doc = uo_cr.of_maxdoc(ldt_today,'Q')
		if is_doc = '' then
			messagebox("�T������","�i�h�f�渹���o���~�A�еy�ԦA�B�z")
			return
		end if
	
		this.object.rp_no[ll_r] 	= is_doc		
		this.object.type_id[ll_r] 	= '1'   //�i�f
		this.object.hou_no[ll_r]	=  gs_cmp 
		this.object.hou_sour[ll_r] =  gs_cmp 	
		this.object.in_date[ll_r] 	=  datetime(today(),time("00:00:00"))
		this.object.inpidx[ll_r]		= gs_id
		this.object.close_yn[ll_r] =  'N'
		this.object.tax_yn[ll_r] 	= f_callfun('sys_all','intax_way','id',gs_cmp)
		this.trigger event itemchanged(ll_r, this.object.inpidx, gs_id)
		idw_2.object.dis_per.protect = 'no'
		idw_2.object.ubn2.protect = 'no'
	end if
end if


end event

event zer_addrev;//o

string ls_a[] 
datetime ldt_dt

ls_a[1] = this.object.type_id[this.getrow()]
ls_a[2] = this.object.hou_no[this.getrow()]

ls_a[3] = this.object.cust_id[this.getrow()]
ls_a[4] = this.object.inpidx[this.getrow()]
ls_a[5] = this.object.pm100_sname[this.getrow()]
ldt_dt = this.object.in_date[this.getrow()]

this.triggerevent("zer_add")

this.object.type_id[this.getrow()] = ls_a[1]
this.object.hou_no[this.getrow()] = ls_a[2]
this.object.hou_sour[this.getrow()] = ls_a[2]
this.object.cust_id[this.getrow()] = ls_a[3]
this.object.inpidx[this.getrow()] = ls_a[4]
this.object.pm100_sname[this.getrow()] = ls_a[5]
this.object.in_date[this.getrow()] = ldt_dt
end event

event zer_handledberror;call super::zer_handledberror;il_errrow = el_row
end event

event zer_insert;//o
this.triggerevent("zer_add")
end event

event zer_save;//o
datetime ldt_today
long ll_r,ll_cnt
string	ls_itemid ,ls_rpno

dw_3.accepttext()
this.accepttext()
//2005.06.03
if dw_3.rowcount() > 0 then
	ls_itemid = dw_3.object.item_id[dw_3.rowcount()]
	if isnull(ls_itemid) or trim(ls_itemid) = '' then
		dw_3.deleterow(dw_3.rowcount())
	end if
end if
//wf_sum()

super::event zer_save()

if gb_allsave = false  then
		if This.GetItemStatus(il_errrow,0,primary!) = NewModified! then
			if  il_sqlcode = -193  or il_sqlcode = 2601 then
				if messagebox('�s�ɰT��','�i�h�f�渹�e�i��w�Q�ϥΡf~r~n' + &
												 '�аݬO�_�~~��s��',question!,okcancel!,2) <> 1 then
					return
				else
					This.selectrow(0,false)
					ldt_today = datetime(today(),now())
					is_doc = uo_cr.of_maxdoc(ldt_today,'Q')
					this.object.rp_no[il_errrow] = is_doc
					for ll_r = 1 to dw_3.rowcount()
						dw_3.object.rp_no[ll_r] = is_doc
					next 
					this.triggerevent("zer_save")
					if ib_allsave then return
				end if 
			end if
		end if
end if

if this.rowcount() > 0 then
	//��ܮֳ�B�٭���s
	ls_rpno = this.object.rp_no[this.getrow()]
	if is_user_check = 'Y' then 
		ll_cnt  = wf_chk_ok(ls_rpno)		//�ˬd�|���ֳ浧��
		if ll_cnt < 1 then
			this.object.cb_ok.visible = 'no'
		else
			this.object.cb_ok.visible = 'yes'
		end if
	end if
	
	if is_user_recover = 'Y' then 
		ll_cnt = 0
		ll_cnt = wf_chk_cancel(ls_rpno)		//�ˬd�i�ֳ��٭쵧��
		if ll_cnt < 1 then
			this.object.cb_cancel.visible = 'no'
		else
			this.object.cb_cancel.visible = 'yes'
		end if
	end if
end if

end event

event rowfocuschanged;call super::rowfocuschanged;long		ll_cnt
string	ls_rpno
dwitemstatus	ldw_status

if currentrow < 1 then	return

if currentrow <> idw_1.getrow() then
	idw_1.setrow(currentrow)
	idw_1.scrolltorow(currentrow)
end if

//2004.04.30
ldw_status = this.getitemstatus(currentrow, 0, primary!)

if ldw_status = new! or ldw_status = newmodified! then
	if is_user_check = 'Y' then this.object.cb_ok.visible = 'yes'
	if is_user_recover = 'Y' then this.object.cb_cancel.visible = 'no'
	return
end if

ls_rpno = this.object.rp_no[currentrow]
wf_check_inv_dw2(currentrow)	//�T�{�o���J�}���A
if is_user_check = 'Y' then 
	ll_cnt  = wf_chk_ok(ls_rpno)		//�ˬd�|���ֳ浧��
	if ll_cnt < 1 then
		this.object.cb_ok.visible = 'no'
	else
		this.object.cb_ok.visible = 'yes'
	end if
end if

if is_user_recover = 'Y' then 
	ll_cnt = 0
	ll_cnt = wf_chk_cancel(ls_rpno)		//�ˬd�i�ֳ��٭쵧��
	if ll_cnt < 1 then
		this.object.cb_cancel.visible = 'no'
	else
		this.object.cb_cancel.visible = 'yes'
	end if
end if

end event

event rowfocuschanging;//o
gb_allsave = true
ib_allsave = true
dw_3.ib_allsave = true
super::event rowfocuschanging(currentrow,newrow)
//
if gb_allsave = false  or ib_allsave = false then return 1
end event

event buttonclicked;call super::buttonclicked;string ls_rpno,ls_null,ls_cust,ls_old,ls_inv_no,ls_hou_no,ls_invno
datetime	ldt_null ,ldt_in_date
long		ll_cnt ,ll_rtn
integer i

this.accepttext()
if dwo.name = 'cb_cus' then
	ls_cust = this.object.cust_id[getrow()]
	openwithparm(w_pm100_pop, ls_cust)
	return
end if

if dw_3.rowcount() = 0 then return
ls_rpno = this.object.rp_no[row]
setnull(ldt_null)
setnull(ls_null)

if dwo.name = 'cb_upd' then
//	if idw_2.object.cp_must_retrieve[row] = 'Y' then
//		messagebox('�T��','���i�h�f��w�ֳ�A���i�s��!~r~n�Э��s�d��!')
//		return
//	end if	
	
	for i=1 to dw_3.rowcount()
		dw_3.object.inv_in_price[i] = dw_3.object.ap_mon[i]
	next
	wf_sum_inv()
	dw_3.triggerevent("zer_save")
	messagebox('�T��','�ץ�����')
	
	ls_invno = this.object.inv_no[row]
	//�p�G����ɨS����J�o�����X�Aap310�L�k�g�J�o�����ӡA����~��J�o�����X�S�|�]�����Ӹ�Ƴ��Onotmodify�A�s�ɹL�{���|�]���Ӧs�ɨ��@�q�A
	//�ҥH�j����ܪ��A��datamodify
	if ls_invno = '' or isnull(ls_invno) then
		for i=1 to dw_3.rowcount()
			dw_3.SetItemStatus(i, "inv_in_price",Primary!, DataModified!)
		next
	end if
	return
end if

if dwo.name = 'cb_1' or dwo.name = 'cb_2' or dwo.name = 'cb_4' then
	if dwo.name = 'cb_1' then
		ls_rpno = ls_rpno + '^' + '1'
	elseif dwo.name = 'cb_2' then
		ls_rpno = ls_rpno + '^' + '2'
	else
		ls_rpno = ls_rpno + '^' + '4'
	end if
	OpenWithParm(w_im340_prt, ls_rpno)
end if

if dwo.name = 'cb_3' or dwo.name = 'cb_5' then
	if dwo.name = 'cb_3' then
		ls_rpno = ls_rpno + '^' + '3'
	elseif dwo.name = 'cb_5' then
		ls_rpno = ls_rpno + '^' + '5'
	end if
	OpenWithParm(w_im340_prt2, ls_rpno)
end if

if dwo.name = 'cb_ok' then	//�ֳ�
	//chk enable or disable
	dw_3.accepttext()
	if idw_2.object.cp_must_retrieve[row] = 'Y' then
		messagebox('�T��','���i�h�f��w�ֳ�A���i�s��!~r~n�Э��s�d��!')
		return
	end if	
	this.triggerevent('zer_save')
	if not gb_allsave then return	//�s�ɥ��Ѥ��~��
	
	ls_rpno = this.object.rp_no[row]	//�s�ɹL�{�i�঳���s����
	
	if idw_2.object.cp_must_retrieve[row] = 'Y' then
		return
	end if	
	ll_cnt = wf_chk_ok(ls_rpno)	//2004.04.30
	if ll_cnt < 1 then
		messagebox('��ưT��','�d�L��ƥi�ֳ�,�Ьd����A�ֳ�!')
		return
	end if
	tab_1.tabpage_3.dw_4.object.rp_no_fa[1] = ls_rpno
	tab_1.tabpage_3.dw_4.object.rp_no_fb[1] = ls_rpno
	tab_1.tabpage_3.dw_4.object.hou_no_fa[1] = ''
	tab_1.tabpage_3.dw_4.object.hou_no_fb[1] = ''
	tab_1.tabpage_3.dw_4.object.cust_id_fa[1] = ''
	tab_1.tabpage_3.dw_4.object.cust_id_fb[1] = ''
	tab_1.tabpage_3.dw_4.object.in_date_fa[1] = ldt_null
	tab_1.tabpage_3.dw_4.object.in_date_fb[1] = ldt_null
	tab_1.tabpage_3.dw_4.object.chk_sw[1] = 'Y'
	ls_old = tab_1.tabpage_3.dw_6.is_user_read
	tab_1.tabpage_3.dw_6.is_user_read = 'Y'
	tab_1.tabpage_3.dw_4.event buttonclicked(1,actionreturncode,tab_1.tabpage_3.dw_4.object.cb_1)
	tab_1.tabpage_3.dw_6.is_user_read = ls_old
	if tab_1.tabpage_3.dw_6.rowcount() < 1 then
		messagebox('��ưT��','�d�L���Ӹ�ƥi�ֳ�,�Ьd����A�ֳ�!')
		return 
	end if
	tab_1.tabpage_3.dw_5.event buttonclicked(1,actionreturncode,tab_1.tabpage_3.dw_5.object.cb_1)
	wf_chk_qty(ls_rpno)
	idw_3.triggerevent('zer_mretrieve')

end if
if dwo.name = 'cb_cancel' then	//�ֳ��٭�	
	//chk enable or disable
	if (not isnull(this.object.ubc2[row])) and trim(this.object.ubc2[row])<>'' then
		messagebox('��ưT��','�w����ǲ�,���i�٭�!')
		return
	end if
	ll_cnt = wf_chk_cancel(ls_rpno)	//2004.04.30
	if ll_cnt < 1 then
		messagebox('��ưT��','�d�L��ƥi�٭�,�Ьd����A�ֳ��٭�!')
		return
	end if
	tab_1.tabpage_4.dw_7.object.rp_no_fa[1] = ls_rpno
	tab_1.tabpage_4.dw_7.object.rp_no_fb[1] = ls_rpno
	tab_1.tabpage_4.dw_7.object.hou_no_fa[1] = ''
	tab_1.tabpage_4.dw_7.object.hou_no_fb[1] = ''
	tab_1.tabpage_4.dw_7.object.cust_id_fa[1] = ''
	tab_1.tabpage_4.dw_7.object.cust_id_fb[1] = ''
	tab_1.tabpage_4.dw_7.object.in_date_fa[1] = ldt_null
	tab_1.tabpage_4.dw_7.object.in_date_fb[1] = ldt_null
	tab_1.tabpage_4.dw_7.object.chk_sw[1] = 'Y'
	tab_1.tabpage_4.dw_7.event buttonclicked(1,actionreturncode,tab_1.tabpage_4.dw_7.object.cb_1)
	if tab_1.tabpage_4.dw_9.rowcount() < 1 then
		messagebox('��ưT��','�d�L���Ӹ�ƥi�ֳ��٭�,�Ьd����A�ֳ��٭�!')
		return 
	end if
	tab_1.tabpage_4.dw_8.event buttonclicked(1,actionreturncode,tab_1.tabpage_4.dw_8.object.cb_1)
	wf_chk_qty(ls_rpno)
	idw_3.triggerevent('zer_mretrieve')
end if



choose case dwo.name
	case 'cb_inv'	//�׶}
		this.triggerevent('zer_save')
		if gb_allsave = false then return
		
		ls_cust = this.object.cust_id[row]
		ls_inv_no = this.object.inv_no[row]
		ls_hou_no = this.object.hou_no[row]
		ldt_in_date = this.object.in_date[row]
		
		if isnull(ls_cust) then ls_cust = ''
		if isnull(ls_inv_no) then ls_inv_no = ''
		
		openwithparm(w_im340_inv,ls_rpno + ',' + ls_cust + ',' +ls_inv_no + ',' + ls_hou_no + ',' + string(ldt_in_date,'yyyy/mm/dd'))
		wf_check_inv_dw2(row)	//�T�{�o���J�}���A
		
	case 'cb_send'	//�e�f
		if invo_scm.of_send(ls_rpno,true) = 1 then
			this.object.acc_chk[row] = '1'
			this.SetItemStatus(row, 'acc_chk',Primary!, NotModified!)
			messagebox('�T��','�e�f����')
		else
			return
		end if
	case 'cb_reset'//�f���٭�
		if invo_scm.of_reset(ls_rpno,true) = 1 then 
			idw_2.object.acc_chk[row] = ls_null
			idw_2.SetItemStatus(row, 'acc_chk',Primary!, NotModified!)
			messagebox('�T��','�f�ֻ�^����')
		else
			return
		end if
end choose
end event
event zer_delete;//o
long	ll_r ,ll_cnt
string ls_rpno,ls_invno,ls_err
if dw_3.rowcount() > 0 then
	for ll_r = 1 to dw_3.rowcount()
		if dw_3.object.chk_qty[ll_r] <> 0 then
			messagebox('��ưT��','���Ӹ�Ƥw�ֳ椣�i�R��!')
			return
		end if
	next
end if

if this.rowcount() > 0 then
	is_del_docid = this.object.doc_id[this.getrow()]
	if wf_save_check() = 1 then return 
end if

//if this.rowcount() > 0 then
//	ls_rpno = this.object.rp_no[this.getrow()]
//	ll_cnt = wf_chk_ok(ls_rpno)
//	if ll_cnt = 0 then
//		messagebox('�T��','���i�h�f��w�ֳ�A���i�s��!~r~n�Э��s�d��!')
//		is_must_re = 'Y'
//		return 
//	end if
//	is_delete = 'Y'
//end if
ls_invno = this.object.inv_no[this.getrow()]
if not (isnull(ls_invno) or ls_invno = '') then
	delete from ap310 where type_id = '1' and inv_id = :ls_invno;
	if sqlca.sqlcode <> 0 then
		ls_err = sqlca.sqlerrtext
		rollback;
		messagebox("�T������"," ap300(���I�o������),�R�����~~n~r" + ls_err)
		return				
	end if
	delete from ap300 where type_id = '1' and inv_id = :ls_invno;
	if sqlca.sqlcode <> 0 then
		ls_err = sqlca.sqlerrtext
		rollback;
		messagebox("�T������"," ap300(���I�o���D��),�R�����~~n~r" + ls_err)
		return				
	end if
end if

super::event zer_delete() 

end event

event getfocus;//o
integer	li_qry
long		ll_cnt
string	ls_rpno, ls_tag
dwitemstatus	ldw_status

if this.getrow() > 0 then
	ls_rpno = this.object.rp_no[this.getrow()]
	ll_cnt = wf_chk_ok(ls_rpno)
	
	ls_tag = this.tag	
	li_qry = pos(ls_tag,"$$") 

	if li_qry > 0 then
		ldw_status = this.getitemstatus(this.getrow(), 0, primary!)
		if ll_cnt > 0 or (ldw_status = new! or ldw_status = newmodified!) or &
			dw_3.rowcount() = 0 then
			ls_tag = replace(ls_tag, li_qry + 5, 1, '+')
		else
			ls_tag = replace(ls_tag, li_qry + 5, 1, '-')
		end if
	end if
	this.tag = ls_tag
end if

Super::EVENT getfocus()

end event

event itemerror;call super::itemerror;return 1
end event

event zer_key;call super::zer_key;integer li_cc
string	ls_1, ls_cust

if keyflags = 2 then		
	choose case key
		case keyq!
			li_cc = this.getcolumn()
			if li_cc > 0 then
				ls_1 = This.describe("#" + string(li_cc)+ ".Name")
				if ls_1 = 'cust_id' then 
					ls_cust = this.object.cust_id[getrow()]
					openwithparm(w_pm100_pop, ls_cust)
					return
				end if
			end if
	end choose
end if
end event

event doubleclicked;call super::doubleclicked;string ls_idno,ls_invid
if dwo.name = 'inv_no_t' then
	this.triggerevent('zer_save')
	if gb_allsave = false then return

	uo_variable.this_parm_s[1] = ''
	open(w_inv_qrcode)
	ls_invid = uo_variable.this_parm_s[1]
	ls_idno = uo_variable.this_parm_s[6]	//�R��νs
	
	if ls_invid = '' then return //�S��J
	
	this.object.inv_no[row] = ls_invid
	this.object.inv_date[row] = datetime(date(uo_variable.this_parm_s[2]))
	if ls_idno = '00000000' then	//�S�νs
		this.object.inv_type[row] = '2'	//�G�p
		this.object.cash_mon[row] = dec(uo_variable.this_parm_s[5])
		this.object.other_mon[row] = 0
	else
		this.object.inv_type[row] = '1'	//�T�p
		this.object.cash_mon[row] = dec(uo_variable.this_parm_s[4])
		this.object.other_mon[row] = dec(uo_variable.this_parm_s[5]) - dec(uo_variable.this_parm_s[4])
	end if
end if
end event

event clicked;call super::clicked;choose case dwo.name
	case 'cust_id_t'
			messagebox("�Ȥ��˯�����", "1.�t�ӥN��  ~r~n" +&
												"2.�Τ@�s��  ~r~n" +&
												"3.�t��²�X(�ҽk)  ~r~n" +&
											   "4.�t�ӦW��(�ҽk)  ~r~n" )  
end choose
end event

type tabpage_3 from userobject within tab_1
integer x = 18
integer y = 120
integer width = 2802
integer height = 1540
long backcolor = 67108864
string text = "�i�f�ֳ�"
long tabtextcolor = 33554432
string picturename = "CheckOut!"
long picturemaskcolor = 16777215
dw_12 dw_12
dw_11 dw_11
dw_10 dw_10
dw_6 dw_6
dw_5 dw_5
dw_4 dw_4
st_v3 st_v3
st_h3 st_h3
end type

on tabpage_3.create
this.dw_12=create dw_12
this.dw_11=create dw_11
this.dw_10=create dw_10
this.dw_6=create dw_6
this.dw_5=create dw_5
this.dw_4=create dw_4
this.st_v3=create st_v3
this.st_h3=create st_h3
this.Control[]={this.dw_12,&
this.dw_11,&
this.dw_10,&
this.dw_6,&
this.dw_5,&
this.dw_4,&
this.st_v3,&
this.st_h3}
end on

on tabpage_3.destroy
destroy(this.dw_12)
destroy(this.dw_11)
destroy(this.dw_10)
destroy(this.dw_6)
destroy(this.dw_5)
destroy(this.dw_4)
destroy(this.st_v3)
destroy(this.st_h3)
end on

type dw_12 from uo_datawindow within tabpage_3
string tag = "/QRY;"
boolean visible = false
integer x = 1879
integer y = 728
integer height = 356
integer taborder = 11
string title = "dw_12"
string dataobject = "w_im330_d_im550_in"
end type

type dw_11 from uo_datawindow within tabpage_3
string tag = "/QRY;"
boolean visible = false
integer x = 1006
integer y = 1020
integer height = 344
integer taborder = 11
string title = "dw_11"
string dataobject = "w_im330_d_pm135_in"
end type

type dw_10 from uo_datawindow within tabpage_3
string tag = "/QRY;"
boolean visible = false
integer x = 1015
integer y = 708
integer width = 818
integer height = 300
integer taborder = 11
string title = "dw_10"
string dataobject = "w_im330_d_pm130_in"
end type

type dw_6 from uo_datawindow within tabpage_3
string tag = "FixedOnLeftHTop&ScaleToRightBottom\\//---$$-----/QRY;/FMTYPE=G;"
integer x = 91
integer y = 704
integer taborder = 11
string dataobject = "w_im340_d_t3_g"
end type

event retrieveend;call super::retrieveend;if rowcount < 1 then return

long ll_r
string ls_chk

ls_chk = dw_4.object.chk_sw[1]

if ls_chk = 'Y' then return

for ll_r = 1 to rowcount
	this.object.chk_sw[ll_r] = ls_chk
next
end event

event retrievestart;call super::retrievestart;if is_user_read = 'N' then return 1
end event

type dw_5 from uo_dwenter within tabpage_3
string tag = "FixedOnVLeftTop&ScaleToRightHBottom\\$$-----//---/QRY;/NOH;/FMTYPE=F;/CB_TEXT=�Х��Ŀ���ֳ椧���;"
integer x = 1906
integer y = 20
integer taborder = 11
end type

event buttonclicked;call super::buttonclicked;if row < 1 then return
if dwo.name <> 'cb_1' then return

long 		ll_r, ll_n = 0, ll_p, ll_q, ll_r2, ll_r3
datetime ldt_now, ldt_in, ldt_today,ldt_close
string 	ls_a[], ls_null, ls_error, ls_cust, ls_itemid, ls_cont_id,ls_hou,ls_prdcls,ls_prdcls_new
decimal  ln_a[], ln_prepay, ln_prepaytot, ln_appay, ln_unbal, ln_avg, ldc_s, ldc_avg, ln_conttot
integer	li_cnt,li_cls
string	ls_yn[],ls_allhou,ls_ubc2
decimal ln_eoscost,ln_tmp,ln_saprice,ln_vip,ln_par_price,ln_sp,ln_ot,ln_emp,ln_per,ln_dif

dw_6.accepttext()
for ll_r =1 to dw_6.rowcount() 
	if dw_6.object.chk_sw[ll_r] = 'Y' then
		ls_hou= dw_6.object.im500_hou_no[ll_r]
		if f_get_close(ls_hou,dw_6.object.im500_in_date[ll_r]) = -1 then //2010.05.20�q���ˬd�O�_�w�w�s�뵲

			messagebox('�T��','�w���w�s�뵲,���i�A���ʦ�������!')
			return
		end if//end of 2010.05.20
		
		ll_n ++
		exit
	end if
next

if ll_n < 1 then 
	messagebox("�����T��","�Х��Ŀ�n�ֳ檺 ���")
	return
end if 

ldt_now = datetime(today(),now())
setnull(ls_null)
//10000.�t�ΰѼƳ]�w
ls_yn[1] = f_callfun('sys_all','in_chgup','id',gs_cmp)	//8.�i�f��s��������T�{�_
ls_yn[2] = f_callfun('sys_all','in_chgcmp','id',gs_cmp)	//7.�i�f��s�D�t�ӽT�{�_
ls_yn[3] = f_callfun('sys_all','incost_avgcvt','id',gs_cmp)	//5.�i�f������s�ɾ�
ls_yn[4] = f_callfun('sys_all','incost_avgcalc','id',gs_cmp)	//11.�i�f�w�s����������k
ls_yn[5] = f_callfun('sys_all','in_costdif','id',gs_cmp)	//11-1.�i�f��s�h�ܦ����_
ls_yn[6] = f_callfun('sys_all','stock_sr','id',gs_cmp)	//13.�����[���X�������v�_


ls_allhou = f_callfun('sys_all','hou_no','id',gs_cmp) //���o�`��

for ll_r = 1 to dw_6.rowcount()
	if dw_6.object.chk_sw[ll_r] = 'Y' then
		//2006.04.10�קK�h�H�@�~�ɭ��ФJ�b
		dw_6.reselectrow(ll_r)
		if (dw_6.object.in_qty[ll_r] + dw_6.object.send_qty[ll_r] <= dw_6.object.chk_qty[ll_r]) or &
			(dw_6.object.im500_close_yn[ll_r] = 'Y') then continue

		is_id	= dw_6.object.im500_inpid[ll_r]
		//insert im310
		ldt_now = datetime(date(ldt_now),RelativeTime ( time(ldt_now), 1 ))
		ls_a[1] = dw_6.object.item_id[ll_r]
		
		if dw_6.object.im500_type_id[ll_r] = '1' then
			ls_a[2] = 'RP'
		else
			ls_a[2] = 'RR'
		end if
		ls_a[3] = dw_6.object.im500_hou_no[ll_r]
		ldt_in = dw_6.object.im500_in_date[ll_r]
		ls_a[4] = dw_6.object.im500_cust_id[ll_r]
		ln_a[1] = dw_6.object.in_price[ll_r]
		ls_a[5]= dw_6.object.mea[ll_r]
		//03.05.23
		ln_a[2] = dw_6.object.in_qty[ll_r] + dw_6.object.send_qty[ll_r] - dw_6.object.chk_qty[ll_r]
		ln_a[3] = dw_6.object.inmon[ll_r] - dw_6.object.dis_mon[ll_r]
		ls_a[6] = dw_6.object.rp_no[ll_r]
		ls_a[7] = dw_6.object.cmt[ll_r]
		ls_a[8] = dw_6.object.im500_hou_sour[ll_r]
		ls_a[9] = dw_6.object.im500_doc_id[ll_r] 
		ls_a[10] =dw_6.object.up_dis[ll_r]
		ln_a[4] = dw_6.object.send_qty[ll_r]
		ln_a[5] = dw_6.object.seqno[ll_r]	
		ln_a[7] = dw_6.object.cost_old[ll_r]
		ln_a[10] = dw_6.object.give_per[ll_r]
		
		//�i�f������s�ɾ����ֳ��,2005.08.12�h�f���ݧ�s����
		if ls_yn[3] = '2' and dw_6.object.im500_type_id[ll_r] = '1' and ls_a[1] <> 'DISCOUNT' then
			select isnull(avg_cost,0),isnull(stock,0)
				into :ldc_avg,:ldc_s
				from pd120
				where item_id = :ls_a[1] and hou_no = :ls_a[3];
			if sqlca.sqlcode <> 0 then
				ldc_avg = 0
				ldc_s = 0
			end if
//			select isnull(stock,0)
//				into :ldc_s
//				from pd120
//				where item_id = :ls_a[1] and hou_no = :ls_a[3];
//			if sqlca.sqlcode <> 0 then
//				ldc_s = 0
//			end if
			ln_avg = 0
			choose case ls_yn[4]	//�w�s����������k 
				case '1'				//�[�v����;2007.10.03�w�s�p��s�����즨��(Meg)
					if ldc_s >= 0 then
						if (ldc_s + ln_a[2]) <> 0 then
							ln_avg = ((ldc_s * ldc_avg) + ln_a[3]) / (ldc_s + ln_a[2])
						else
							ln_avg = ldc_avg
						end if
					else
						if ln_a[2] <> 0 then 
							ln_avg = ln_a[3] / ln_a[2]
						else
							ln_avg = ln_a[1]
						end if
					end if
					ln_a[8] = ldc_s	//2008.04.16
					ln_a[9] = ldc_avg
				case '2'				//��i��
					ln_avg = ln_a[1]
				case '3'				//��즨��
					if ln_a[2] <> 0 then
						if ln_a[3] <> 0 then
							ln_avg = ln_a[3] / ln_a[2]
						elseif ln_a[2] + ldc_s <> 0 then
							ln_avg = (ldc_s * ldc_avg) / (ln_a[2] + ldc_s)
						else
							ln_avg = ln_a[1]
						end if
					else
						ln_avg = ln_a[1]
					end if
				case '4'				//������
					ln_avg = ldc_avg
			end choose

			//��s�ӫ~����
			select isnull(sa_price,0), prd_cls, isnull(vip_price,0),
					 isnull(par_price,0),isnull(sp_price,0),isnull(ot_price,0),isnull(emp_price,0)
				into :ln_saprice, :ls_prdcls,:ln_vip,:ln_par_price,:ln_sp,:ln_ot,:ln_emp
				from pd100
				where item_id = :ls_a[1];
				
			li_cls = f_callfun_num('sys_all', 'crad_daymsg', 'id', ls_hou)
			if isnull(ln_avg) then ln_avg = 0
			ln_tmp = ln_saprice
			choose case li_cls
				case 1
					ln_tmp = ln_saprice
				case 2
					ln_tmp = ln_vip
				case 3
					ln_tmp = ln_par_price
				case 4
					ln_tmp = ln_sp
				case 5
					ln_tmp = ln_ot
				case 6
					ln_tmp = ln_emp
			end choose
			
			if isnull(ln_tmp) then ln_tmp = 0
			if ln_tmp = 0 then
				ln_per = 0
			else
				ln_dif = ln_tmp - ln_avg
				ln_per = round(ln_dif * 100 / ln_tmp,2)
			end if
			
			SELECT max(pd180.prd_cls)  INTO :ls_prdcls_new  
				FROM pd180  
				WHERE ( pd180.score_st <= :ln_per ) AND ( pd180.score_end >= :ln_per );
			if sqlca.sqlcode <> 0 then
				ls_prdcls_new = ls_prdcls
			end if
		
		
		  //2004.04.14�P�@�ܤ~��spd100��������
		  select count(1) into :li_cnt from sys100 where id = :ls_a[3];
		  if li_cnt > 0 then
			  UPDATE pd100  
				  SET avg_cost = :ln_avg,
						prd_cls = :ls_prdcls_new
				WHERE pd100.item_id = :ls_a[1];
				if sqlca.sqlcode <> 0 then
					ls_error = sqlca.sqlerrtext
					rollback;
					messagebox('��ưT��','pd100(�ӫ~�D��) �������� ��s����!~r~n' + ls_error)
					return
				end if
			end if
		
			if ls_allhou = gs_cmp then
				//�`��
				ln_eoscost = ln_avg
			else
				select eos_cost into :ln_eoscost
				  from pd120
				 where item_id = :ls_a[1]
					and hou_no = :ls_allhou;
				if sqlca.sqlcode <> 0 or isnull(ln_eoscost) then ln_eoscost = 0
			end if
			
			//030506
			if ls_yn[5] = 'Y' then	//�i�f��s�h�ܦ����_
				UPDATE pd120  
					  SET avg_cost = :ln_avg ,
							eos_cost = :ln_eoscost
					WHERE ( pd120.item_id = :ls_a[1] );
				if sqlca.sqlcode <> 0 then
					ls_error = sqlca.sqlerrtext
					rollback;
					messagebox('��ưT��','pd120(�ӫ~�w�s����) �h�ܥ������� ��s����!~r~n' + ls_error)
					return
				end if
			else
				UPDATE pd120  
					  SET avg_cost = :ln_avg ,
							eos_cost = :ln_eoscost

					WHERE ( pd120.item_id = :ls_a[1] ) AND  
							( pd120.hou_no = :ls_a[3] );
				if sqlca.sqlcode <> 0 then
					ls_error = sqlca.sqlerrtext
					rollback;
					messagebox('��ưT��','pd120(�ӫ~�w�s����) �������� ��s����!~r~n' + ls_error)
					return
				end if
			end if
			

			if f_factor_cost(ls_a[1],ln_avg,ls_a[3],ln_a[1]) = 1 then return	//2007.11.22�p��즨��
			if ls_yn[1] = 'Y' then	//�i�f��s��������T�{�_
				UPDATE pd100  
					SET in_price = :ln_a[1]  
				WHERE pd100.item_id = :ls_a[1];
				if sqlca.sqlcode <> 0 then
					ls_error = sqlca.sqlerrtext
					rollback;
					messagebox('��ưT��','pd100(�ӫ~�D��) ��i��  ��s����!~r~n' + ls_error)
					return
				end if
				UPDATE pd120  
					SET in_price = :ln_a[1]  
					WHERE ( pd120.item_id = :ls_a[1] ) AND  
							( pd120.hou_no = :ls_a[3] );
				if sqlca.sqlcode <> 0 then
					ls_error = sqlca.sqlerrtext
					rollback;
					messagebox('��ưT��','pd120(�ӫ~�w�s����) ��i�� ��s����!~r~n' + ls_error)
					return
				end if
				if ls_a[10] <> '1' then
					UPDATE pm120  
						  SET supply_pri = :ln_a[1],
								send_per = :ln_a[10]
						WHERE ( pm120.cust_id = :ls_a[4] ) AND  
								( pm120.item_id = :ls_a[1] );
					if sqlca.sqlcode <> 0 then
						ls_error = sqlca.sqlerrtext
						rollback;
						messagebox('��ưT��','pm120(�t�ӳ����) ������ ��s����!~r~n' + ls_error)
						return
					end if
				end if
			end if
			
			if  ls_yn[2] = 'Y' then		//�i�f��s�D�t�ӽT�{�_
				//2003.12.22 MEG �t�ӥN�����ܮw�N��
				ls_ubc2 = f_callfun('im110','ubc2','hou_no',ls_a[3])	//�w�O�������t�ӫȤ�N��
				if isnull(ls_ubc2) then ls_ubc2 = ''						//�i�f�ܧO�D������,��s�D�n�t��
				if (f_callfun_count_2('im110','hou_no',ls_a[4]) = 0 and ls_ubc2='') or &
				   (f_callfun_count_2('im110','ubc2',ls_a[4]) = 0 and ls_ubc2 <> '') then
						UPDATE pd100  
							SET cust_id = :ls_a[4]  
						WHERE pd100.item_id = :ls_a[1];
						if sqlca.sqlcode <> 0 then
							ls_error = sqlca.sqlerrtext
							rollback;
							messagebox('��ưT��','pd100(�ӫ~�D��)�� �t�ӥN�� ��s����!~r~n' + ls_error)
							return
						end if
				end if
			end if
		end if
		//2005.12.16 �W�[avg_cost�g�J

		INSERT INTO im310  
			( item_id,   inptime,   tr_code,   hou_no,   tr_date,   cust_id,   po_no,   
			  po_seq,   un_price,   dollar_id,   mea,   factor,   tr_qty,   tr_mon,   
			  tr_doc,   stock_qty,   loc_id,   remark,   inpid,   updid,   updtime,   
			  ubc1,       ubc2,      ubn1,     ubn2,     ubd1,     ubd2,   cmp_code,	avg_cost )  
		VALUES ( :ls_a[1], :ldt_now, :ls_a[2], :ls_a[3],   :ldt_in,   :ls_a[4],   :ls_null,   
					0,      :ln_a[1],  'NTD', :ls_a[5],     1,  :ln_a[2],   :ln_a[3],   
					:ls_a[6],   0,   :ls_null,   :ls_a[7],   :is_id,   :is_id,   :ldt_now,   
					:ls_null,   :ls_null, :ln_a[4], :ln_a[5],   null,   null,   :gs_cmp,	:ln_a[7] )  ;
		if sqlca.sqlcode <> 0 then
			ls_error = sqlca.sqlerrtext
			rollback;
			messagebox('��ưT��','�w�s���ʩ�����(IM310) �s�W����!~r~n' + ls_error)
			return
		end if
		
		//2002.11.03 retrieve PM130/PM135
		ln_prepaytot = 0.000
		if ls_a[1] <> 'DISCOUNT' then	//2006.09.07
		if dw_6.object.im500_type_id[ll_r] = '1' then	//�i�f, �X���B�z
			if (dw_6.object.in_qty[ll_r] > 0 or dw_6.object.send_qty[ll_r] > 0) then
				ls_cust = ls_a[4]
				dw_10.retrieve(ls_cust,ldt_in)
				dw_11.retrieve(ls_cust,ldt_in)
				dw_12.reset()
				if dw_10.rowcount() > 0 then
					ln_appay = dw_6.object.inmon[ll_r] - dw_6.object.dis_mon[ll_r]
					ln_prepay = 0.000
					ln_prepaytot = 0.000
					ls_itemid = ls_a[1]
					for ll_p = 1 to dw_10.rowcount()
						//���R�P����
						ln_unbal = dw_10.object.tot_mon[ll_p] - dw_10.object.set_mon[ll_p] - dw_10.object.cc_prepay[ll_p]
						//messagebox(string(ln_unbal),string(ln_appay))
//						if ln_unbal > 0 and dw_10.object.close_yn[ll_p] = 'N' then
						if dw_10.object.close_yn[ll_p] = 'N' then
							ls_cont_id = dw_10.object.cont_id[ll_p]
							li_cnt = 0
							if dw_11.rowcount() > 0 then	//�ݲŦX �Ƹ�����
								for ll_q = 1 to dw_11.rowcount()

									if dw_11.object.cont_id[ll_q] = ls_cont_id and &
										dw_11.object.pm135_item_id[ll_q] = ls_itemid then
										li_cnt ++
										exit
									end if
								next
							end if
							if dw_10.object.cc_itemcnt[ll_p] = 0 or li_cnt > 0 then
								ln_unbal = ln_unbal - (ln_appay - ln_prepaytot)
								ln_prepay = ln_appay - ln_prepaytot
								ln_prepaytot = ln_prepaytot + ln_prepay
								dw_10.object.cc_prepay[ll_p] = dw_10.object.cc_prepay[ll_p] + ln_prepay
								//insert dw_12 -> insert pm137
								ll_r2 = dw_12.insertrow(0)
								dw_12.object.rp_no[ll_r2]   = ls_a[6]
								dw_12.object.seqno[ll_r2]   = ln_a[5]		//�Ǧ�
								dw_12.object.item_id[ll_r2] = ls_itemid
								dw_12.object.ubc1[ll_r2]    = ls_cont_id
								dw_12.object.ubn1[ll_r2]    = ln_prepay
							end if
						end if
					next
					dw_6.object.ubn1[ll_r] = ln_prepaytot	//�w�I���B

				else
					dw_6.object.ubn1[ll_r] = 0	//�w�I���B
				end if
			else
				dw_6.object.ubn1[ll_r] = 0	//�w�I���B
			end if
			if dw_12.rowcount() > 0 then
				ldt_today = datetime(today(),now())
				for ll_r3 = 1 to dw_12.rowcount()
					ll_n       = dw_12.object.seqno[ll_r3]		//�Ǧ�
					ls_itemid  = dw_12.object.item_id[ll_r3]
					ls_cont_id = dw_12.object.ubc1[ll_r3]
					ln_prepay  = dw_12.object.ubn1[ll_r3]
					INSERT INTO pm137  
						( cont_id,   inptime,   rp_no,   seqno,   cont_dist,   item_id,   
						 set_mon,   totset_mon,   in_price,   in_qty,   send_qty,   mea,   
						 inmon,   sub_mon,   cmt,   inpid,   updid,   updtime,   
						 ubc1,   ubc2,   ubn1,   ubn2,   ubd1,   ubd2,   cmp_code )  
					VALUES ( :ls_cont_id,   :ldt_now,   :ls_a[6],   :ll_n,   '1',   :ls_itemid,   

								:ln_prepay,   0,   0,   :ln_a[2],   0,   0,   
								0,   0,   '�q���إ�',   :is_id,   :is_id,   :ldt_today,   
								null,   null,   0,   0,   null,   null,   :gs_cmp )  ;
					if sqlca.sqlcode <> 0 then
						ls_error = sqlca.sqlerrtext
						rollback;
						messagebox('��ưT��','�X�����ʩ�����(PM137) �s�W����!~r~n' + ls_error)
						return
					end if
					//�����[��X�������v
					if ls_yn[6] = 'Y' then    //13.�����[���X�������v�_
						if upperbound(ln_a) < 9 then
							select avg_cost into :ln_a[8] from pd120 where item_id = :ls_itemid and hou_no = :ls_a[3];
							if isnull(ln_a[8]) then ln_a[8] = 0
							ln_a[9] = ln_a[8]
						end if
						wf_avgcost(ls_a[],ln_a[],ls_itemid,ls_cont_id)
					end if
				next
			end if
		else	//�h�f
			if dw_6.object.im500_type_id[ll_r] = '2' then
				if (dw_6.object.in_qty[ll_r] > 0 or dw_6.object.send_qty[ll_r] > 0) then
					ls_cust = ls_a[4]
					dw_10.retrieve(ls_cust,ldt_in)
					dw_11.retrieve(ls_cust,ldt_in)
					dw_12.reset()
					if dw_10.rowcount() > 0 then
						ln_appay = dw_6.object.inmon[ll_r] - dw_6.object.dis_mon[ll_r]
						ln_prepay = 0.000
						ln_prepaytot = 0.000
						ls_itemid = ls_a[1]
						for ll_p = 1 to dw_10.rowcount()
							//���٭짹��
							ln_unbal = dw_10.object.set_mon[ll_p] - dw_10.object.cc_prepay[ll_p]
							//messagebox(string(ln_unbal),string(ln_appay))
							//if ln_unbal > 0 then
							if dw_10.object.close_yn[ll_p] = 'N' then
								ls_cont_id = dw_10.object.cont_id[ll_p]
								li_cnt = 0
								if dw_11.rowcount() > 0 then	//�ݲŦX �Ƹ�����
									for ll_q = 1 to dw_11.rowcount()
										if dw_11.object.cont_id[ll_q] = ls_cont_id and &
											dw_11.object.pm135_item_id[ll_q] = ls_itemid then
											li_cnt ++
											exit
										end if
									next
								end if
								if dw_10.object.cc_itemcnt[ll_p] = 0 or li_cnt > 0 then
									ln_unbal = ln_unbal - (ln_appay - ln_prepaytot)
									ln_prepay = ln_appay - ln_prepaytot
									ln_prepaytot = ln_prepaytot + ln_prepay
									dw_10.object.cc_prepay[ll_p] = dw_10.object.cc_prepay[ll_p] + ln_prepay
									//insert dw_12 -> insert pm137
									ll_r2 = dw_12.insertrow(0)
									dw_12.object.rp_no[ll_r2]   = ls_a[6]
									dw_12.object.seqno[ll_r2]   = ln_a[5]		//�Ǧ�
									dw_12.object.item_id[ll_r2] = ls_itemid
									dw_12.object.ubc1[ll_r2]    = ls_cont_id
									dw_12.object.ubn1[ll_r2]    = ln_prepay
									//2004.11.02 disable	
//									if (ln_unbal - ln_appay + ln_prepaytot) >= 0 then
//										ln_unbal = ln_unbal - (ln_appay - ln_prepaytot)
//										ln_prepay = ln_appay - ln_prepaytot
//										ln_prepaytot = ln_prepaytot + ln_prepay
//										dw_10.object.cc_prepay[ll_p] = dw_10.object.cc_prepay[ll_p] + ln_prepay
//										//insert dw_12 -> insert pm137
//										ll_r2 = dw_12.insertrow(0)
//										dw_12.object.rp_no[ll_r2]   = ls_a[6]
//										dw_12.object.seqno[ll_r2]   = ln_a[5]		//�Ǧ�
//										dw_12.object.item_id[ll_r2] = ls_itemid
//										dw_12.object.ubc1[ll_r2]    = ls_cont_id
//										dw_12.object.ubn1[ll_r2]    = ln_prepay
//										exit
//									else
//										//dw_10.object.cc_prepay[ll_p] = dw_10.object.tot_mon[ll_p] - dw_10.object.set_mon[ll_p]

//										//ln_prepay = ln_unbal - ln_prepaytot
//										dw_10.object.cc_prepay[ll_p] = dw_10.object.set_mon[ll_p]
//										ln_prepay = ln_unbal
//										ln_prepaytot = ln_prepaytot + ln_prepay
//										//insert dw_12 -> insert pm137
//										ll_r2 = dw_12.insertrow(0)
//										dw_12.object.rp_no[ll_r2]   = ls_a[6]
//										dw_12.object.seqno[ll_r2]   = ln_a[5]		//�Ǧ�
//										dw_12.object.item_id[ll_r2] = ls_itemid
//										dw_12.object.ubc1[ll_r2]    = ls_cont_id
//										dw_12.object.ubn1[ll_r2]    = ln_prepay
//									end if
								end if
							end if
						//	end if
						next
						dw_6.object.ubn1[ll_r] = ln_prepaytot	//�w�I���B
					else
						dw_6.object.ubn1[ll_r] = 0	//�w�I���B
					end if
				else
					dw_6.object.ubn1[ll_r] = 0	//�w�I���B
				end if
				ls_cont_id = ''
				if dw_12.rowcount() > 0 then
					ldt_today = datetime(today(),now())
					for ll_r3 = 1 to dw_12.rowcount()
						ll_n       = dw_12.object.seqno[ll_r3]		//�Ǧ�
						ls_itemid  = dw_12.object.item_id[ll_r3]
						ls_cont_id = dw_12.object.ubc1[ll_r3]
						ln_prepay  = 0 - dw_12.object.ubn1[ll_r3]
						INSERT INTO pm137  
							( cont_id,   inptime,   rp_no,   seqno,   cont_dist,   item_id,   
							 set_mon,   totset_mon,   in_price,   in_qty,   send_qty,   mea,   
							 inmon,   sub_mon,   cmt,   inpid,   updid,   updtime,   
							 ubc1,   ubc2,   ubn1,   ubn2,   ubd1,   ubd2,   cmp_code )  
						VALUES ( :ls_cont_id,   :ldt_now,   :ls_a[6],   :ll_n,   '1',   :ls_itemid,   
									:ln_prepay,   0,   0,   (0 - :ln_a[2]),   0,   0,   
									0,   0,   '�q���إ�',   :is_id,   :is_id,   :ldt_today,   
									null,   null,   0,   0,   null,   null,   :gs_cmp )  ;
						if sqlca.sqlcode <> 0 then
							ls_error = sqlca.sqlerrtext
							rollback;

							messagebox('��ưT��','�X�����ʩ�����(PM1370) �s�W����!~r~n' + ls_error)
							return
						end if
					next
				end if
			end if
		end if
		end if //end of DISCOUNT
		//update im550 chk_qty
		//ln_a[6] = dw_6.object.ubn1[ll_r]	//�w�I���B
		
		if dw_6.object.im500_type_id[ll_r] = '1' then
			if ls_a[9] <> '' and ls_a[8] <> ls_a[3] then  //���;2022.01.10�[�W�ܧO�M�ӷ��ܤ��P����
				li_cnt = 0
				select count(1) into :li_cnt from im800 where hou_no = :ls_a[3] and doc_id = :ls_a[9];
				if li_cnt > 0 then
					update im800
						set close_yn = 'Y',
							 rp_no = :ls_a[6]
					 where hou_no = :ls_a[3]
						//and item_id = :ls_a[1] �@�w����
						and doc_id = :ls_a[9];
					if sqlca.sqlcode <> 0 then
						ls_error = sqlca.sqlerrtext
						rollback;
						messagebox('��ưT��','���ʰӫ~���ʩ�����(IM800) ��s����!~r~n' + ls_error)
						return
					end if 
				else
					update im850 
						set ubc1 = 'Y'
					where hou_no = :ls_a[3] and
							doc_id = :ls_a[9];
					if sqlca.sqlcode <> 0 then
						ls_error = sqlca.sqlerrtext
						rollback;
						messagebox('��ưT��','���ʰӫ~�h�ܽ����p�X���ʩ�����(im850) ��s����!~r~n' + ls_error)
						return
					end if 	
				end if
			end if
		end if
		
		ln_a[6] = ln_prepaytot
		update im550
		   set chk_qty = chk_qty + :ln_a[2],
				 ubn1 = :ln_a[6],
				 ubc1 = :ls_cont_id
		 where  rp_no = :ls_a[6] and seqno = :ln_a[5];
		if sqlca.sqlcode <> 0 then
			ls_error = sqlca.sqlerrtext
			rollback;
			messagebox('��ưT��','im550(�i�f�h�f������) ���ʥ���!~r~n' + ls_error)
			return
		end if		 
		     
	end if
next

commit;
messagebox("�����T��","�ֳ�@�~ ����")
idw_2.object.cb_ok.visible = 'no'	//2004.04.30
if is_user_recover = 'Y' then
	idw_2.object.cb_cancel.visible = 'yes'
else

	idw_2.object.cb_cancel.visible = 'no'
end if
dw_6.reset()
end event

type dw_4 from uo_dwqry within tabpage_3
string tag = "FixedOnLeftTop&ScaleToVRightHBottom\\$$-----//---/QRY;/NOH;/FMTYPE=F;"
integer x = 5
integer width = 1687
integer height = 644
integer taborder = 11
string dataobject = "w_im340_d_t3_qry"
end type

event constructor;call super::constructor;idwo_qry = dw_6
end event

type st_v3 from vo_v1 within tabpage_3
integer x = 1774
integer y = 212
integer width = 73
end type

event constructor;call super::constructor;idrag_l[1] = dw_4
idrag_r[1] = dw_5
end event

type st_h3 from vo_h1 within tabpage_3
integer x = 1371
integer y = 736
end type

event constructor;call super::constructor;idrag_u[1] = dw_4
idrag_u[2] = st_v3
idrag_u[3] = dw_5
idrag_d[1] = dw_6

end event

type tabpage_4 from userobject within tab_1
integer x = 18
integer y = 120
integer width = 2802
integer height = 1540
long backcolor = 67108864
string text = "�ֳ��٭�"
long tabtextcolor = 33554432
string picturename = "Custom094!"
long picturemaskcolor = 16777215
dw_9 dw_9
dw_8 dw_8
dw_7 dw_7
st_h4 st_h4
st_v4 st_v4
end type

on tabpage_4.create
this.dw_9=create dw_9
this.dw_8=create dw_8
this.dw_7=create dw_7
this.st_h4=create st_h4
this.st_v4=create st_v4
this.Control[]={this.dw_9,&
this.dw_8,&
this.dw_7,&
this.st_h4,&
this.st_v4}
end on

on tabpage_4.destroy
destroy(this.dw_9)
destroy(this.dw_8)
destroy(this.dw_7)
destroy(this.st_h4)
destroy(this.st_v4)
end on

type dw_9 from uo_datawindow within tabpage_4
string tag = "FixedOnLeftHTop&ScaleToRightBottom\\//---$$-----/QRY;/FMTYPE=G;"
integer x = 677
integer y = 916
integer taborder = 11
string dataobject = "w_im340_d_t4_g"
end type

event retrieveend;call super::retrieveend;if rowcount < 1 then return

long ll_r
string ls_chk

ls_chk = dw_7.object.chk_sw[1]

if ls_chk = 'Y' then return

for ll_r = 1 to rowcount
	this.object.chk_sw[ll_r] = ls_chk
next
end event

type dw_8 from uo_dwenter within tabpage_4
string tag = "FixedOnVLeftTop&ScaleToRightHBottom\\$$-----//---/QRY;/NOH;/FMTYPE=F;/CB_TEXT=�Х��Ŀ���٭줧���;"
integer x = 1879
integer y = 116
integer width = 823
integer taborder = 11
end type

event buttonclicked;call super::buttonclicked;string	ls_hou
datetime	ldt_close

if row < 1 then return
if dwo.name <> 'cb_1' then return

long ll_r ,ll_n = 0 
for ll_r =1 to dw_9.rowcount() 
	if dw_9.object.chk_sw[ll_r] = 'Y' then
		ls_hou= dw_9.object.im500_hou_no[ll_r]
		if f_get_close(ls_hou,dw_9.object.im500_in_date[ll_r]) = -1 then	//2010.05.20�q���ˬd�O�_�w�w�s�뵲
			messagebox('�T��','�w���w�s�뵲,���i�A���ʦ�������!')
			return
		end if//end of 2010.05.20
		
		ll_n ++
		exit
	end if
next

if ll_n < 1 then 
	messagebox("�����T��","�Х��Ŀ�n�٭쪺 ���")
	return
end if 

datetime ldt_now,ldt_in
string ls_a[],ls_null,ls_error
decimal ln_a[]

ldt_now = datetime(today(),now())
setnull(ls_null)

for ll_r =1 to dw_9.rowcount()
	if dw_9.object.chk_sw[ll_r] = 'Y' then
		//2006.04.10�קK�h�H�@�~�ɭ��ФJ�b
		dw_9.reselectrow(ll_r)
		if dw_9.object.chk_qty[ll_r] <= 0 or dw_9.object.im500_close_yn[ll_r] = 'Y' then continue
		
		//insert im310
		ldt_now = datetime(date(ldt_now),RelativeTime ( time(ldt_now), 1 ))
		ls_a[1] = dw_9.object.item_id[ll_r]
		if dw_9.object.im500_type_id[ll_r] = '1' then
			ls_a[2] = 'RP'
		else
			ls_a[2] = 'RR'
		end if
		ls_a[3] = dw_9.object.im500_hou_no[ll_r]
		ldt_in = dw_9.object.im500_in_date[ll_r]
		ls_a[4] = dw_9.object.im500_cust_id[ll_r]
		ln_a[1] = dw_9.object.in_price[ll_r]
		ls_a[5]= dw_9.object.mea[ll_r]
		ln_a[2] = 0 - dw_9.object.chk_qty[ll_r]
		ln_a[3] = dw_9.object.inmon[ll_r] - dw_9.object.dis_mon[ll_r]
		ls_a[6] = dw_9.object.rp_no[ll_r]
		ls_a[7] = dw_9.object.cmt[ll_r]
		ln_a[4] = dw_9.object.send_qty[ll_r]
		ln_a[5] = dw_9.object.seqno[ll_r]		
		ln_a[6] = 0
		ln_a[7] = dw_9.object.cost_old[ll_r]
		INSERT INTO im310  
			( item_id,   inptime,   tr_code,   hou_no,   tr_date,   cust_id,   po_no,   
			  po_seq,   un_price,   dollar_id,   mea,   factor,   tr_qty,   tr_mon,   
			  tr_doc,   stock_qty,   loc_id,   remark,   inpid,   updid,   updtime,   
			  ubc1,       ubc2,      ubn1,     ubn2,     ubd1,     ubd2,   cmp_code,	avg_cost )  
		VALUES ( :ls_a[1], :ldt_now, :ls_a[2], :ls_a[3],   :ldt_in,   :ls_a[4],   :ls_null,   
					0,      :ln_a[1],  'NTD', :ls_a[5],     1,  :ln_a[2],   :ln_a[3],   
					:ls_a[6],   0,   :ls_null,   :ls_a[7],   :is_id,   :is_id,   :ldt_now,   
					:ls_null,   :ls_null, :ln_a[4], :ln_a[5],   null,   null,   :gs_cmp,	:ln_a[7] )  ;
		if sqlca.sqlcode <> 0 then
			ls_error = sqlca.sqlerrtext
			rollback;
			messagebox('��ưT��','�w�s���ʩ�����(IM310) �s�W����!~r~n' + ls_error)
			return
		end if
		//update im550 chk_qty
		//   set chk_qty = chk_qty + :ln_a[2]
		update im550
		   set chk_qty = 0
		 where  rp_no = :ls_a[6] and seqno = :ln_a[5];
		if sqlca.sqlcode <> 0 then
			ls_error = sqlca.sqlerrtext
			rollback;
			messagebox('��ưT��','im550(�i�f�h�f������) ���ʥ���!~r~n' + ls_error)
			return
		end if		 
		
		delete from pm137  
		where rp_no = :ls_a[6] and seqno = :ln_a[5];
		if sqlca.sqlcode <> 0 then
			ls_error = sqlca.sqlerrtext
			rollback;
			messagebox('��ưT��','�X�����ʩ�����(PM1370) �R������!~r~n' + ls_error)
			return
		end if
	end if
next

commit;
messagebox("�����T��","�٭�@�~ ����")
idw_2.object.cb_cancel.visible = 'no'		//2004.04.30
if is_user_check = 'Y' then 
	idw_2.object.cb_ok.visible = 'yes'
else
	idw_2.object.cb_ok.visible = 'no'
end if
dw_9.reset()
end event

type dw_7 from uo_dwqry within tabpage_4
string tag = "FixedOnLeftTop&ScaleToVRightHBottom\\$$-----//---/QRY;/NOH;/FMTYPE=F;"
integer x = 9
integer y = 108
integer width = 1687
integer taborder = 11
string dataobject = "w_im340_d_t4_qry"
end type

event constructor;call super::constructor;idwo_qry = dw_9
end event

type st_h4 from vo_h1 within tabpage_4
integer x = 1367
integer y = 748
end type

type st_v4 from vo_v1 within tabpage_4
integer x = 1787
integer y = 208
integer width = 73
end type

event constructor;call super::constructor;idrag_l[1] = dw_7
idrag_r[1] = dw_8
end event

