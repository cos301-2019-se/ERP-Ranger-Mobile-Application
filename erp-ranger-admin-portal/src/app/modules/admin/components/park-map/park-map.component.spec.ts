import { async, ComponentFixture, TestBed } from '@angular/core/testing';

import { ParkMapComponent } from './park-map.component';

describe('ParkMapComponent', () => {
  let component: ParkMapComponent;
  let fixture: ComponentFixture<ParkMapComponent>;

  beforeEach(async(() => {
    TestBed.configureTestingModule({
      declarations: [ ParkMapComponent ]
    })
    .compileComponents();
  }));

  beforeEach(() => {
    fixture = TestBed.createComponent(ParkMapComponent);
    component = fixture.componentInstance;
    fixture.detectChanges();
  });

  it('should create', () => {
    expect(component).toBeTruthy();
  });
});
