import { async, ComponentFixture, TestBed } from '@angular/core/testing';

import { AddMarkerComponent } from './add-marker.component';

describe('AddMarkerComponent', () => {
  let component: AddMarkerComponent;
  let fixture: ComponentFixture<AddMarkerComponent>;

  beforeEach(async(() => {
    TestBed.configureTestingModule({
      declarations: [ AddMarkerComponent ]
    })
    .compileComponents();
  }));

  beforeEach(() => {
    fixture = TestBed.createComponent(AddMarkerComponent);
    component = fixture.componentInstance;
    fixture.detectChanges();
  });

  it('should create', () => {
    expect(component).toBeTruthy();
  });
});
