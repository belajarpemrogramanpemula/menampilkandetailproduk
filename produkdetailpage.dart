import 'package:flutter/material.dart';
import 'package:tokoonline/models/cabang.dart';
import 'package:http/http.dart' as http;
import 'package:tokoonline/constans.dart';
import 'dart:async';
import 'dart:convert';

class ProdukDetailPage extends StatefulWidget {
  final Widget child;
  final int id;
  final String judul;
  final String harga;
  final String hargax;
  final String thumbnail;
  final bool valstok;

  ProdukDetailPage(this.id, this.judul, this.harga, this.hargax, this.thumbnail,
      this.valstok,
      {Key key, this.child})
      : super(key: key);

  @override
  _ProdukDetailPageState createState() => _ProdukDetailPageState();
}

class _ProdukDetailPageState extends State<ProdukDetailPage> {
  List<Cabang> cabanglist = [];
  String _valcabang;
  bool instok = false;

  @override
  void initState() {
    super.initState();
    fetchCabang();
    if (widget.valstok == true) {
      instok = widget.valstok;
    }
  }

  @override
  void dispose() {
    super.dispose();
  }


  Future<List<Cabang>> fetchCabang() async {
    List<Cabang> usersList;
    var params = "/cabang";
    try {
      var jsonResponse = await http.get(Palette.sUrl + params);
      if (jsonResponse.statusCode == 200) {
        final jsonItems =
            json.decode(jsonResponse.body).cast<Map<String, dynamic>>();

        usersList = jsonItems.map<Cabang>((json) {
          return Cabang.fromJson(json);
        }).toList();
        setState(() {
          cabanglist = usersList;
        });
      }
    } catch (e) {}
    return usersList;
  }

  _cekProdukCabang(String idproduk, String idcabang) async {
    var params =
        "/cekprodukbycabang?idproduk=" + idproduk + "&idcabang=" + idcabang;
    try {
      var res = await http.get(Palette.sUrl + params);
      if (res.statusCode == 200) {
        if (res.body == "OK") {
          setState(() {
            instok = true;
          });
        } else {
          setState(() {
            instok = false;
          });
        }
      }
    } catch (e) {
      setState(() {
        instok = false;
      });
    }
  }

  Widget _body() {
    return Container(
      width: double.infinity,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        children: <Widget>[
          Container(
            width: double.infinity,
            child: Image.network(Palette.sUrl +"/"+ widget.thumbnail,
                    fit: BoxFit.fitWidth),
          ),
          Padding(
            padding: EdgeInsets.only(top: 5.0),
            child: Text(widget.judul),
          ),
          Padding(
            padding: EdgeInsets.only(top: 5.0, bottom: 5.0),
            child: Text(widget.harga),
          ),
          Container(
            margin: EdgeInsets.all(10),
            child: DropdownButtonFormField(
              decoration: InputDecoration(
                  contentPadding:
                      EdgeInsets.only(top: 10, left: 12.0, bottom: 10),
                  border: new OutlineInputBorder(
                    borderRadius: const BorderRadius.all(
                      const Radius.circular(5.0),
                    ),
                    borderSide: new BorderSide(
                      color: Colors.black,
                      width: 1.0,
                    ),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.all(Radius.circular(5.0)),
                    borderSide: BorderSide(color: Colors.black, width: 1.0),
                  ),
                  fillColor: Colors.black,
                  filled: false),
              hint: Text("Pilih Cabang"),
              value: _valcabang,
              items: cabanglist.map((item) {
                return DropdownMenuItem(
                  child: Text(item.nama.toString()),
                  value: item.id.toString(),
                );
              }).toList(),
              onChanged: (value) {
                setState(() {
                  _valcabang = value;
                  _cekProdukCabang(widget.id.toString(), _valcabang);
                });
              },
            ),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Transaksi'),
      ),
      body: Stack(
        children: <Widget>[
          SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: <Widget>[
                _body(),
              ],
            ),
          ),
        ],
      ),      
      bottomNavigationBar: BottomAppBar(
        color: Colors.transparent,
        child: Container(
          child: Row(
            children: [
              Padding(
                  padding: EdgeInsets.only(right: 20.0),
                  child: GestureDetector(
                    onTap: (){},
                    child: Container(
                      child: Icon(
                        Icons.favorite_border,
                        size: 40.0,
                      ),
                      decoration: BoxDecoration(
                        color: Colors.grey[100],
                        boxShadow: [
                          BoxShadow(color: Colors.grey[500], spreadRadius: 1),
                        ],
                      ),
                    ),
                  )),
              Padding(
                  padding: EdgeInsets.only(right: 20.0),
                  child: GestureDetector(
                    onTap: () {
                      Navigator.of(context).pushNamedAndRemoveUntil(
                          '/keranjangusers', (Route<dynamic> route) => false);
                    },
                    child: Container(
                      child: Icon(
                        Icons.shopping_cart,
                        size: 40.0,
                      ),
                      decoration: BoxDecoration(
                        color: Colors.grey[100],
                        boxShadow: [
                          BoxShadow(color: Colors.grey[500], spreadRadius: 1),
                        ],
                      ),
                    ),
                  )),
              Expanded(
                child: GestureDetector(
                  onTap: () {
                    if (instok == true) {
                      // Keranjang _keranjangku = Keranjang(
                      //     idproduk: widget.id,
                      //     judul: widget.judul,
                      //     harga: widget.harga,
                      //     hargax: widget.hargax,
                      //     thumbnail: widget.thumbnail,
                      //     jumlah: 1,
                      //     userid: userid,
                      //     idcabang: _valcabang);
                      // saveKeranjang(_keranjangku);
                    }
                  },
                  child: Container(
                    height: 40.0,
                    child: Center(
                      child: Text('Beli Sekarang',
                          style: TextStyle(color: Colors.white)),
                    ),
                    decoration: BoxDecoration(
                      color: instok == true ? Colors.blue : Colors.grey,
                      borderRadius: BorderRadius.circular(5),
                      boxShadow: [
                        BoxShadow(
                            color: instok == true ? Colors.blue : Colors.grey,
                            spreadRadius: 1),
                      ],
                    ),
                  ),
                ),
              ),
            ],
          ),
          height: 60.0,
          padding:
              EdgeInsets.only(left: 10.0, right: 10.0, top: 2.0, bottom: 2.0),
          decoration: BoxDecoration(
            color: Colors.grey[100],
            boxShadow: [
              BoxShadow(color: Colors.grey[100], spreadRadius: 1),
            ],
          ),
        ),
        elevation: 0,
      ),
    );
  }
}
