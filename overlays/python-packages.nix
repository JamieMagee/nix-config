# yalexs test dependency aiounittest is disabled for python 3.14
_final: prev: {
  pythonPackagesExtensions = prev.pythonPackagesExtensions ++ [
    (_python-final: python-prev: {
      yalexs = python-prev.yalexs.overridePythonAttrs {
        doCheck = false;
      };
    })
  ];
}
